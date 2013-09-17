{#-
 Diamond statistics for MariaDB
-#}

include:
  - apt
  - diamond
  - mariadb.server
  - python.dev
  - salt.minion.diamond

mysql_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/MySQLCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mariadb/server/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
      - service: mysql-server

mysql_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[mysql]]
        exe = ^\/usr\/sbin\/mysqld

libmariadbclient-dev:
  pkg:
    - installed
    - require:
      - pkgrepo: mariadb
      - cmd: apt_sources
      - pkg: mariadb

diamond_mysql_python:
  file:
    - managed
    - name: /usr/local/diamond/salt-mysql-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mariadb/server/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-mysql-requirements.txt
    - require:
      - virtualenv: diamond
      - pkg: python-dev
      - pkg: libmariadbclient-dev
    - watch:
      - file: diamond_mysql_python

extend:
  diamond:
    service:
      - watch:
        - file: mysql_diamond_collector
        - module: diamond_mysql_python
        - service: mysql-server
