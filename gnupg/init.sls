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
      {%- endif %}
    {%- endfor %}
  {%- endif %}
{%- endfor %}
