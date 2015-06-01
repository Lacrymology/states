{% set users = salt["pillar.get"]("gnupg:users", {}) %}
include:
  - apt

gnupg:
  pkg:
    - latest
    - pkgs:
      - gnupg
      - python-gnupg
    - require:
      - cmd: apt_sources
  cmd: {# API #}
    - wait
    - name: "true"

{%- for user, data in users.iteritems() %}
  {%- set public_keys = data["public_keys"]|default({}) %}
  {%- for keyid, key in public_keys.iteritems() %}
gnupg_import_pub_key_{{ keyid }}_for_user_{{ user }}:
  module:
    - run
    - name: gpg.import_key
    - user: {{ user }}
    - text: |
        {{ key|indent(8) }}
    - require:
      - pkg: gnupg
    - require_in:
      - cmd: gnupg
      - file: gnupg_fix_gnupghome_owner_{{ user }}
  {%- endfor %}

  {%- set private_keys = data["private_keys"]|default({}) %}
  {%- for key_id, key in private_keys.iteritems() %}
gnupg_import_priv_key_{{ key_id }}_for_user_{{ user }}:
  cmd:
    - run
    - name: |
        echo "{{ key|indent(8) }}" | gpg --no-tty --batch --import -
    - user: {{ user }}
    - require:
      - pkg: gnupg
    - unless: gpg --list-secret-keys --with-colons | grep {{ key_id }}
  {%- endfor %}

  {%- if 'gpg' in salt["sys.list_modules"]() %}
    {%- set imported_keys = salt["gpg.list_keys"]() %}
    {%- for imported_key in imported_keys %}
      {#- The public is also imported when importing a secret key
      So, secret key must be deleted first before deleting the public key #}
      {%- if imported_key["keyid"] not in public_keys and imported_key["keyid"] not in private_keys %}
gnupg_delete_pub_key_{{ imported_key["keyid"] }}_for_user_{{ user }}:
  module:
    - run
    - name: gpg.delete_key
    - user: {{ user }}
    - keyid: {{ imported_key["keyid"] }}
    - require:
      - pkg: gnupg
      - cmd: gnupg_delete_all_priv_keys_for_user_{{ user }}
    - require_in:
      - cmd: gnupg
      - file: gnupg_fix_gnupghome_owner_{{ user }}
      {%- endif %}
    {%- endfor %}

    {%- set imported_private_keys = salt["gpg.list_secret_keys"]() %}
    {%- for imported_private_key in imported_private_keys %}
      {%- if imported_private_key["keyid"] not in private_keys %}
gnupg_delete_priv_key_{{ imported_private_key["keyid"] }}_for_user_{{ user }}:
  module:
    - run
    - name: gpg.delete_key
    - user: {{ user }}
    - keyid: {{ imported_private_key["keyid"] }}
    - delete_secret: True
    - require:
      - pkg: gnupg
    - require_in:
      - cmd: gnupg
      - file: gnupg_fix_gnupghome_owner_{{ user }}
    - watch_in:
      - cmd: gnupg_delete_all_priv_keys_for_user_{{ user }}
      {%- endif %}
    {%- endfor %}
  {%- endif %}

gnupg_delete_all_priv_keys_for_user_{{ user }}:
  cmd:
    - wait
    - name: echo "The keys from secret keyrings but not defined in the pillar has been deleted"

  {#- workaround for incorrect owner for files in ~/.gnupg #}
  {%- set user_info = salt["user.info"](user) %}
gnupg_fix_gnupghome_owner_{{ user }}:
  file:
    - directory
    - name: {{ user_info["home"] }}/.gnupg
    - recurse:
      - user
      - group
    - user: "{{ user }}"
  {%- if user == "root" %}
    - group: root  {#- 0 number will count as False boolean value #}
  {%- else %}
    - group: {{ user_info["gid"] }}
  {%- endif %}
    - require_in:
      - cmd: gnupg
{%- endfor %}
