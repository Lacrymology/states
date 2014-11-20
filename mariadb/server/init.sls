{#-
Copyright (C) 2013 the Institute for Institutional Innovation by Data
Driven Design Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the names of the Institute for
Institutional Innovation by Data Driven Design Inc. shall not be used in
advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the
Institute for Institutional Innovation by Data Driven Design Inc.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - mariadb
{% if salt['pillar.get']('mysql:ssl', False) %}
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
    - source: salt://mariadb/server/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - makedirs: True

remove_bin_log:
  cmd:
    - run
    - name: rm -f /var/log/mysql/mariadb-bin.*
    - onlyif: ls /var/log/mysql/mariadb-bin.*
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
    - installed
    - name: mariadb-server
    - require:
      - pkgrepo: mariadb
      - pkg: mariadb
      - file: /etc/mysql/my.cnf
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
{%- if salt['pillar.get']('mysql:ssl', False) %}
      - cmd: ssl_cert_and_key_for_{{ pillar['mysql']['ssl'] }}
{%- endif %}
      - user: mysql-server
    - require:
      - pkg: mysql-server
  debconf:
    - set
    - name: mariadb-server-5.5
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': {{ salt['password.pillar']('mysql:password') }}}
        'mysql-server/root_password_again': {'type': 'password', 'value': {{ salt['password.pillar']('mysql:password') }}}
    - require:
      - pkg: apt_sources
  user:
    - present
    - name: mysql
    - shell: /bin/false
  {%- if salt['pillar.get']('mysql:ssl', False) %}
    - groups:
      - ssl-cert
  {%- endif %}
    - require:
      - pkg: mariadb-server
