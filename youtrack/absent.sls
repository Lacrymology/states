{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/var/lib/youtrack:
  file:
    - absent
    - require:
      - service: youtrack

/usr/local/youtrack:
  file:
    - absent
    - require:
      - service: youtrack

/etc/nginx/conf.d/youtrack.conf:
  file:
    - absent
    - require:
      - service: youtrack

/etc/youtrack:
  file:
    - absent
    - require:
      - service: youtrack

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('youtrack') }}

extend:
  youtrack:
    user:
      - absent
      - require:
        - service: youtrack
