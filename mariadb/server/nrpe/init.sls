{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - mariadb.nrpe
  - nrpe
{%- if salt['pillar.get']('mysql:ssl', False) %}
  - ssl.nrpe
{%- endif %}

nrpe_mysql_check_querry:
  file:
    - managed
    - name: /usr/local/nagios/salt-mysql-query-check-requirements.txt
    - source: salt://mariadb/server/nrpe/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/salt-mysql-query-check-requirements.txt
    - watch:
      - file: nrpe_mysql_check_querry

/usr/lib/nagios/plugins/check_mysql_query.py:
  file:
    - managed
    - source: salt://mariadb/server/nrpe/check_mysql_query.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - module: nrpe_mysql_check_querry
      - pkg: nagios-nrpe-server

{{ passive_check('mariadb.server') }}
