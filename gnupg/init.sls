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
  {%- set import_keys = data["import_keys"]|default({}) %}
  {%- for keyid, key in import_keys.iteritems() %}
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

  {%- if 'gpg' in salt["sys.list_modules"]() %}
    {%- set imported_keys = salt["gpg.list_keys"]() %}
    {%- for imported_key in imported_keys %}
      {%- if imported_key["keyid"] not in import_keys %}
gnupg_delete_pub_key_{{ imported_key["keyid"] }}_for_user_{{ user }}:
  module:
    - run
    - name: gpg.delete_key
    - user: {{ user }}
    - keyid: {{ imported_key["keyid"] }}
    - require:
      - pkg: gnupg
    - require_in:
      - cmd: gnupg
      - file: gnupg_fix_gnupghome_owner_{{ user }}
      {%- endif %}
    {%- endfor %}
  {%- endif %}

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
      {%- endif %}
    {%- endfor %}
  {%- endif %}

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
