{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{%- set version = '0.20.6' -%}
{%- set server_root_dir = '/usr/local/graylog2-server-' + version -%}
{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') -%}

{{ upstart_absent('graylog2-server') }}
{{ upstart_absent('graylog2-server-prep') }}

extend:
  graylog2-server:
    user:
      - absent
      - name: {{ user }}
      - require:
        - service: graylog2-server
    group:
      - absent
      - name: {{ user }}
      - require:
        - user: graylog2-server

{%- for file in ('/etc/graylog2.conf', server_root_dir, '/etc/graylog2') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog2-server
{% endfor %}

/var/log/graylog2:
  file:
    - absent
    - require:
      - service: graylog2-server

/var/lib/graylog2/server-node-id:
  file:
    - absent
    - require:
      - service: graylog2-server

graylog2_rsyslog_config:
  file:
    - absent
    - name: /etc/rsyslog.d/graylog2-server.conf
