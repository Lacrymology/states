{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context -%}
{%- set ssl = salt['pillar.get']('mysql:ssl', False) %}
include:
  - apt
  - mysql
{% if ssl %}
  - ssl
{% endif %}

/etc/mysql:
  file:
    - directory
    - mode: 755
    - user: root
    - group: root

/etc/mysql/my.cnf:
  file:
    - managed
    - source: salt://mysql/server/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - makedirs: True
    - require:
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
      - file: /etc/mysql
      - user: mysql-server

remove_bin_log:
  cmd:
    - run
    - name: rm -f /var/log/mysql/mysql-bin.*
    - onlyif: ls /var/log/mysql/mysql-bin.*
    - watch_in:
      - service: mysql-server

/etc/mysql/my.cnf.dpkg-dist:
  file:
    - absent
    - require:
      - pkg: mysql-server

python-mysqldb:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

{%- call manage_pid('/var/run/mysqld/mysqld.pid', 'mysql', 'mysql', 'mysql-server', 660) %}
- pkg: mysql-server
{%- endcall %}

mysql-server:
  pkg:
    - latest
    - name: mysql-server
    - require:
      - pkg: mysql
      - debconf: mysql-server
      - pkg: python-mysqldb
  {#-
  mysqld_safe used the logger command to log the error messages to the syslog.
  With `ps`, you will see something like this:

    logger -t mysqld -p daemon.error

  `-t` for tag and `-p` for priority.

  The tag can be configured with `--syslog-tag` parameter:
  http://dev.mysql.com/doc/refman/5.5/en/mysqld-safe.html#option_mysqld_safe_syslog-tag

  The priority defines which facility and level the message should be logged.
  Unfortunately, this is hard-coded in the `mysqld_safe` script.

  This hack is to make it configurable as well.

  After patching, to log to the `local3.info` for example,
  change the configuration file `/etc/mysql/conf.d/mysqld_safe_syslog.cnf` as follows:

    [mysqld_safe]
    syslog
    syslog-priority = local3.info

  Source: http://shinguz.blogspot.com/2010/01/mysql-reporting-to-syslog.html
  #}
  cmd:
    - run
    - name: sed -i -e '/syslog_tag_mysqld_safe=mysqld_safe/a syslog_priority=daemon.info' -e 's|daemon.error|$syslog_priority|g' -e '/syslog_tag="$val" ;;/a\      --syslog-priority=*) syslog_priority="$val" ;;' /usr/bin/mysqld_safe
    - unless: egrep 'daemon.info|syslog_priority|--syslog-priority' /usr/bin/mysqld_safe
    - require:
      - pkg: mysql-server
    - watch_in:
      - service: mysql-server
  service:
    - name: mysql
    - running
    - enable: True
    - order: 50
    - watch:
      - file: /etc/mysql/my.cnf
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
      - user: mysql-server
    - require:
      - pkg: mysql-server
  debconf:
    - set
    - name: mysql-server-5.5
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': {{ salt['password.pillar']('mysql:password') }}}
        'mysql-server/root_password_again': {'type': 'password', 'value': {{ salt['password.pillar']('mysql:password') }}}
    - require:
      - pkg: apt_sources
  user:
    - present
    - name: mysql
    - shell: /bin/false
  {%- if ssl %}
    - groups:
      - ssl-cert
  {%- endif %}
    - require:
      - pkg: mysql-server
