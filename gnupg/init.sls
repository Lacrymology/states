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
  {%- set private_keys = data["private_keys"]|default({}) %}

  {%- for key_type in ("public", "private") %}
    {%- if key_type == "public" %}
      {%- set import_keys = public_keys %}
    {%- elif key_type =="private" %}
      {%- set import_keys = private_keys %}
    {%- endif %}

    {%- for keyid, key in import_keys.iteritems() %}
      {%- if key_type == "public" %}
gnupg_import_pub_key_{{ keyid }}_for_user_{{ user }}:
      {%- elif key_type =="private" %}
gnupg_import_priv_key_{{ keyid }}_for_user_{{ user }}:
      {%- endif %}
  cmd:
    - run
    - name: |
        echo "{{ key|indent(8) }}" | gpg --no-tty --batch --import -
    - user: {{ user }}
    - require:
      - pkg: gnupg
    - require_in:
      - cmd: gnupg
      {%- if key_type == "public" %}
    - unless: gpg --list-keys --with-colons | grep {{ keyid }}
      {%- elif key_type == "private" %}
    - unless: gpg --list-secret-keys --with-colons | grep {{ keyid }}
      {%- endif %}
    {%- endfor %}
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
    - watch_in:
      - cmd: gnupg_delete_all_priv_keys_for_user_{{ user }}
      {%- endif %}
    {%- endfor %}
  {%- endif %}

gnupg_delete_all_priv_keys_for_user_{{ user }}:
  cmd:
    - wait
    - name: echo "The keys from secret keyrings but not defined in the pillar has been deleted"
{%- endfor %}
