{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}

/etc/nginx/conf.d/graylog2-web.conf:
  file:
    - absent
    - require_in:
      - service: graylog2-web

{{ upstart_absent('graylog2-web') }}

extend:
  graylog-web:
    user:
      - absent
      - require:
        - service: graylog-web
    group:
      - absent
      - require:
        - user: graylog-web

/etc/graylog/web:
  file:
    - absent
    - require:
      - service: graylog-web
