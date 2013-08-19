{#-
MariaDB Daemon
=============

Install MariaDB, a database server which is a drop-in replacement for MySQL

Mandatory Pillar
----------------

mysql:
  password: root_plaintext_password

mysql:password: root password used for installation process, change this after
    MariaDB installed does not make sense.


Optional Pillar
---------------
mysql:
  utf8: True/False
  bind: 0.0.0.0

mysql:utf8: Enable or disable charset utf8. If disable, Latin1 charset will be
            used. Default: False
mysql:bind: what IP does MariaDB server will bind to. Default: 0.0.0.0
-#}

include:
  - apt
  - mariadb

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
  service:
    - name: mysql
    - running
    - enable: True
    - watch:
      - file: /etc/mysql/my.cnf
    - require:
      - pkg: mysql-server
  debconf:
    - set
    - name: mariadb-server-5.5
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': {{ salt['pillar.get']('mysql:password') }}}
        'mysql-server/root_password_again': {'type': 'password', 'value': {{ salt['pillar.get']('mysql:password') }}}
    - require:
      - pkg: debconf-utils
