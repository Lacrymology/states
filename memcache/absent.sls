{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('memcached') }}

extend:
  memcached:
    pkg:
      - purged
      - require:
        - service: memcached

/var/run/memcache/memcache.sock:
  file:
    - absent
    - require:
      - service: memcached
