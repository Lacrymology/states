{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Install a ProFTPd FTP server.
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
    - name: {{ salt['pillar.get']('proftpd:db:username', 'proftpd') }}
    - password: {{ salt['password.pillar']('proftpd:db:password', 10) }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('proftpd:db:name', 'proftpd') }}
    - owner: {{ salt['pillar.get']('proftpd:db:username', 'proftpd') }}
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
    - name: psql -f {{ opts['cachedir'] }}/proftpd.sql proftpd
    - user: postgres
    - group: postgres
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

{% for deployment in salt['pillar.get']('proftpd:deployments', []) %}
/var/lib/deployments/{{ deployment }}/static/ftp:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 770
    - makedirs: True
    - require:
      - file: web
{% endfor %}
