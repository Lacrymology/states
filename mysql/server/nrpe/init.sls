{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - mysql.nrpe
  - nrpe
{%- if salt['pillar.get']('mysql:ssl', False) %}
  - ssl.nrpe
{%- endif %}

/usr/local/nagios/salt-mysql-query-check-requirements.txt:
  file:
    - absent

nrpe_mysql_check_querry:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/mysql.server.nrpe
    - source: salt://mysql/server/nrpe/requirements.jinja2
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
    - requirements: {{ opts['cachedir'] }}/pip/mysql.server.nrpe
    - watch:
      - file: nrpe_mysql_check_querry

/usr/lib/nagios/plugins/check_mysql_query.py:
  file:
    - managed
    - source: salt://mysql/server/nrpe/check_mysql_query.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - module: nrpe_mysql_check_querry
      - pkg: nagios-nrpe-server

{{ passive_check('mysql.server') }}
