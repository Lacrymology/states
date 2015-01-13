{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
include:
  - apt.nrpe
  - nrpe
  - postgresql.common.nrpe
  - postgresql.nrpe
  - postgresql.server
  - rsyslog.nrpe
{% if ssl %}
  - ssl.nrpe
{% endif %}

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql

nrpe_pgsql_check_querry:
  file:
    - managed
    - name: /usr/local/nagios/salt-pgsql-query-check-requirements.txt
    - source: salt://postgresql/server/nrpe/requirements.jinja2
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
    - requirements: /usr/local/nagios/salt-pgsql-query-check-requirements.txt
    - watch:
      - file: nrpe_pgsql_check_querry

/usr/lib/nagios/plugins/check_pgsql_query.py:
  file:
    - managed
    - source: salt://postgresql/server/nrpe/check_pgsql_query.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - module: nrpe_pgsql_check_querry
      - pkg: nagios-nrpe-server
