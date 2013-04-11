{#
 WARNING

 FTP is a insecure and crappy protocol, I would never use that.
 Please do not use this state.

 But a client wanted to upload files from a special software used
 during sports competitions.
 They wanted to have the results available on their website.
 And it only support FTP.

 So, I made this state as less intrusive as possible in the rest of the system.
 I wrote it to depends on already existing PostgreSQL server to not
 not mess with Unix users/passwords.
 It's probably more secure this way.
 #}

include:
  - apt
  - postgresql.server
  - nrpe
  - diamond

proftpd-basic:
  debconf:
    - set
    - data:
        'shared/proftpd/inetd_or_standalone': {'type': 'select', 'value': 'standalone'}
    - require:
      - pkg: debconf-utils
  pkg:
    - installed
    - require:
      - debconf: proftpd-basic

proftpd-mod-pgsql:
  pkg:
    - installed
    - require:
      - pkg: proftpd-basic
  postgres_user:
    - present
    - name: proftpd
    - password: {{ pillar['proftpd']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: proftpd
    - owner: proftpd
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
    - mode: 644
  service:
    - running
    - require:
      - postgres_database: proftpd-mod-pgsql
      - cmd: proftpd-users
      - service: postgresql
    - watch:
      - file: proftpd
      - pkg: proftpd-mod-pgsql
      - pkg: proftpd-basic

/etc/nagios/nrpe.d/proftpd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://proftpd/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

proftpd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[proftpd]]
        exe = ^\/usr\/sbin\/proftpd$

{% for file in ('virtuals', 'tls', 'sql', 'modules', 'ldap') %}
/etc/proftpd/{{ file }}.conf:
  file:
    - absent
{% endfor %}

/var/log/proftpd/xferlog:
  file:
    - absent

{% for deployment in pillar['proftpd']['deployments'] %}
/var/lib/deployments/{{ deployment }}/static/ftp:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 770
    - makedirs: True
{% endfor %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/proftpd.cfg
