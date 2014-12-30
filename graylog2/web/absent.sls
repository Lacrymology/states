{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{%- set version = '0.20.6' -%}
{%- set web_root_dir = '/usr/local/graylog2-web-interface-' + version -%}
{%- set user = salt['pillar.get']('graylog2:web:user', 'graylog2-ui') -%}

{{ upstart_absent('graylog2-web') }}
{{ upstart_absent('graylog2-web-prep') }}

/etc/logrotate.d/graylog2-web:
  file:
    - absent

extend:
  graylog2-web:
    user:
      - absent
      - name: {{ user }}
      - require:
        - service: graylog2-web
    group:
      - absent
      - name: {{ user }}
      - require:
        - user: graylog2-web

/etc/nginx/conf.d/graylog2-web.conf:
  file:
    - absent
    - require_in:
      - service: graylog2-web

{{ web_root_dir }}:
  file:
    - absent
    - require:
      - service: graylog2-web

{%- for command in ('streamalarms', 'subscriptions') %}
/etc/cron.hourly/graylog2-web-{{ command }}:
  file:
    - absent
{%- endfor %}

/var/log/graylog2-ui:
  file:
    - absent
    - require:
      - service: graylog2-web
