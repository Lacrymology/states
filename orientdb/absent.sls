{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}

{{ upstart_absent('orientdb') }}

{%- for file in ('/etc', '/var/lib', '/tmp') %}
{{ file }}/orientdb:
  file:
    - absent
    - require:
      - service: orientdb
{%- endfor %}

{%- for version in ('2.0.6', '2.1.0') %}
/usr/local/orientdb-community-{{ version }}:
  file:
    - absent
    - require:
      - service: orientdb
{%- endfor %}

orientdb-console:
  file:
    - absent
    - name: /usr/local/bin/orientdb

extend:
  orientdb:
    group:
      - absent
      - require:
        - user: orientdb
    user:
      - absent
      - require:
        - service: orientdb
