{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- from "upstart/absent.sls" import upstart_absent with context %}
{%- set ssl = salt['pillar.get']('graylog2:ssl', False) %}

include:
  - graylog2
  - java.7
  - local
  - logrotate
  - mongodb
  - nginx
  - rsyslog
{% if ssl %}
  - ssl
{% endif %}
  - web
  - sudo

{% set version = '0.20.6' %}
{% set checksum = 'md5=27d20967a7de68ead66f66ff07de281c' %}
{% set user = salt['pillar.get']('graylog2:web:user', 'graylog2-ui') %}
{% set web_root_dir = '/usr/local/graylog2-web-interface-' + version %}

{#-
{% for previous_version in () %}
/usr/local/graylog2-web-interface-{{ previous_version }}:
  file:
    - absent
{% endfor %}
#}

graylog2-web-{{ user }}:
  user:
    - present
    - name: {{ user }}
    - home: /var/run/{{ user }}
    - shell: /bin/false

/var/run/{{ user }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - makedirs: True
    - require:
      - user: graylog2-web-{{ user }}

/var/log/{{ user }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 775
    - makedirs: True
    - require:
      - user: graylog2-web-{{ user }}

{{ web_root_dir }}/logs:
  file:
    - symlink
    - force: True
    - target: /var/log/{{ user }}
    - require:
      - archive: graylog2-web
      - file: /var/log/{{ user }}

graylog2-web-logrotate:
  file:
    - managed
    - name: /etc/logrotate.d/graylog2-web
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://graylog2/web/logrotate.jinja2
    - require:
      - pkg: logrotate

graylog2-web.conf:
  file:
    - managed
    - name: {{ web_root_dir }}/conf/graylog2-web-interface.conf
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - source: salt://graylog2/web/config.jinja2
    - require:
      - archive: graylog2-web
      - user: graylog2-web-{{ user }}

graylog2-web:
  file:
    - managed
    - name: /etc/init/graylog2-web.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - source: salt://graylog2/web/upstart.jinja2
    - context:
        web_root_dir: {{ web_root_dir }}
        user: {{ user }}
    - require:
      - pkg: sudo
  archive:
    - extracted
    - name: /usr/local/
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/graylog2-web-interface-{{ version }}.tar.gz
{%- else %}
    - source: http://packages.graylog2.org/releases/graylog2-web-interface/graylog2-web-interface-{{ version }}.tgz
{%- endif %}
    - source_hash: {{ checksum }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  service:
    - running
    - enable: True
    - watch:
      - file: graylog2-web
      - file: graylog2-web.conf
      - pkg: jre-7
      - file: jre-7
      - archive: graylog2-web
      - user: graylog2-web-{{ user }}
    - require:
      - file: /var/run/{{ user }}
      - file: /var/log/{{ user }}

{{ manage_upstart_log('graylog2-web') }}

{% for command in ('streamalarms', 'subscriptions') %}
/etc/cron.hourly/graylog2-web-{{ command }}:
  file:
    - absent
{% endfor %}

/etc/nginx/conf.d/graylog2-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://graylog2/web/nginx.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
    - context:
        version: {{ version }}

{% if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}

{%- from 'macros.jinja2' import manage_pid with context %}
{%- call manage_pid('/var/run/graylog2-web/graylog2-web.pid', user , 'syslog', 'graylog2-web') %}
- user: graylog2-web-{{ user }}
- file: /var/run/{{ user }}
- pkg: rsyslog
{%- endcall %}
