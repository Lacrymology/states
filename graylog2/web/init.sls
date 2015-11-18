{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- from "upstart/absent.sls" import upstart_absent with context %}
{%- set ssl = salt['pillar.get']('graylog2:ssl', False) %}

include:
  - graylog2
  - java.7
  - local
  - logrotate
  - nginx
  - rsyslog
{% if ssl %}
  - ssl
{% endif %}
  - web

{% set user = 'graylog-web' %}

{{ upstart_absent('graylog2-web') }}

/usr/local/graylog2-web-interface-0.20.6:
  file:
    - absent
    - require_in:
      - service: graylog2-web

/etc/logrotate.d/graylog2-web:
  file:
    - absent

/var/run/graylog2-ui:
  file:
    - absent
    - require_in:
      - service: graylog2-web

/var/log/graylog2-ui:
  file:
    - absent
    - require_in:
      - service: graylog2-web

/etc/graylog/web/web.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: {{ user }}
    - mode: 440
    - source: salt://graylog2/web/config.jinja2
    - require:
      - pkg: graylog-web

/etc/default/graylog-web:
  file:
    - managed
    - template: jinja
    - user: root
    - group: {{ user }}
    - mode: 440
    - source: salt://graylog2/web/default.jinja2
    - require:
      - pkg: graylog-web

/etc/graylog/web/logback.xml:
  file:
    - managed
    - template: jinja
    - user: root
    - group: {{ user }}
    - mode: 440
    - source: salt://graylog2/web/logback.jinja2
    - require:
      - pkg: graylog-web
      - service: rsyslog

/var/log/graylog-web:
  file:
    - absent
    - require:
      - service: graylog-web

graylog-web:
  pkg:
    - latest
    - require:
      - pkgrepo: graylog
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/graylog/web/web.conf
      - file: /etc/default/graylog-web
      - file: /etc/graylog/web/logback.xml
      - pkg: jre-7
      - file: jre-7
      - pkg: graylog-web

/etc/nginx/conf.d/graylog2-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://graylog2/web/nginx.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - context:
        appname: graylog2
        root: /var/www
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

{#- remove old graylog2-web user #}
extend:
  graylog2-web:
    user:
      - absent
      - name: graylog2-ui
      - require:
        - service: graylog2-web
    group:
      - absent
      - name: graylog2-ui
      - require:
        - user: graylog2-web
{% if ssl %}
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
