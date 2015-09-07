{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- from "upstart/absent.sls" import upstart_absent with context %}
{{ upstart_absent("syncthing") }}

extend:
  syncthing:
    user:
      - absent
      - purge: True
      - require:
        - service: syncthing
    group:
      - absent
      - require:
        - user: syncthing
    pkg:
      - purged
      - require:
        - service: syncthing

/etc/nginx/conf.d/syncthing.conf:
  file:
    - absent
    - require:
      - service: syncthing

/etc/apt/sources.list.d/syncthing.list:
  file:
    - absent
