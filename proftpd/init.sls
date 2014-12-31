{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}

include:
  - apt
  - postgresql.server
  - rsyslog
  - web

proftpd-basic:
  debconf:
    - set
    - data:
        'shared/proftpd/inetd_or_standalone': {'type': 'select', 'value': 'standalone'}
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - require:
      - debconf: proftpd-basic
      - cmd: apt_sources

proftpd-mod-pgsql:
  pkg:
    - installed
    - require:
      - pkg: proftpd-basic
      - cmd: apt_sources
  postgres_user:
    - present
{%- set username = salt['pillar.get']('proftpd:db:username', 'proftpd') %}
    - name: {{ username }}
    - password: {{ salt['password.pillar']('proftpd:db:password', 10) }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('proftpd:db:name', 'proftpd') }}
    - owner: {{ username }}
    - runas: postgres
    - require:
      - postgres_user: proftpd-mod-pgsql

proftpd-users:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/proftpd.sql
    - user: postgres
    - group: postgres
    - mode: 440
    - template: jinja
    - source: salt://proftpd/sql.jinja2
    - require:
      - pkg: postgresql
  cmd:
    - wait
    - name: cat {{ opts['cachedir'] }}/proftpd.sql | su - postgres -s /bin/bash -c 'psql proftpd'
    - user: root
    - group: root
    - require:
      - postgres_database: proftpd-mod-pgsql
      - service: postgresql
    - watch:
      - file: proftpd-users

proftpd:
  file:
    - managed
    - name: /etc/proftpd/proftpd.conf
    - template: jinja
    - source: salt://proftpd/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: proftpd-basic
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - postgres_database: proftpd-mod-pgsql
      - cmd: proftpd-users
      - service: postgresql
      - user: web
      - service: rsyslog
    - watch:
      - file: proftpd
      - pkg: proftpd-mod-pgsql
      - pkg: proftpd-basic
{#- PID file owned by root, no need to manage #}

{% for file in ('virtuals', 'tls', 'sql', 'modules', 'ldap') %}
/etc/proftpd/{{ file }}.conf:
  file:
    - absent
    - require:
      - service: proftpd
{% endfor %}

/var/log/proftpd/xferlog:
  file:
    - absent
    - require:
      - service: proftpd

{% for account in salt['pillar.get']('proftpd:accounts', {}) %}
/var/lib/deployments/{{ account }}/static/ftp:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 770
    - makedirs: True
    - require:
      - file: web
{% endfor %}
