{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Uninstall memcache.
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('memcached') }}

extend:
  memcached:
    pkg:
      - purged
      - require:
        - service: memcached

/tmp/memcached.sock:
  file:
    - absent
    - require:
      - service: memcached
