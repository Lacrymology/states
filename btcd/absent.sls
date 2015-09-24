{#- Usage of this is governed by a license that can be found in doc/license.rst #}

{%- from "btcd/map.jinja2" import btcd with context %}
{%- from "upstart/absent.sls" import upstart_absent with context -%}

{{ upstart_absent("btcd") }}

{%- for file in (btcd.install_dir, "/etc/btcd", "/var/lib/btcd",
                 "/var/log/btcd", "/etc/logrotate.d/btcd") %}
{{ file }}:
  file:
    - absent
    - require:
      - service: btcd
{%- endfor %}

extend:
  btcd:
    user:
      - absent
      - purge: True
      - require:
        - service: btcd
