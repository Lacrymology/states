{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
# postgresql client side checks

{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
include:
  - apt.nrpe
  - postgresql
  - python.dev
{% if ssl %}
  - ssl.nrpe
{% endif %}

nrpe_check_pgsql_query:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/postgresql.nrpe
    - user: root
    - group: root
    - mode: 440
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}
        psycopg2==2.4.5
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: {{ opts['cachedir'] }}/pip/postgresql.nrpe
    - watch:
      - pkg: python-dev
      - pkg: postgresql-dev
      - file: nrpe_check_pgsql_query

/usr/lib/nagios/plugins/check_pgsql_query.py:
  file:
    - managed
    - source: salt://postgresql/nrpe/check_pgsql_query.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - module: nrpe_check_pgsql_query
      - pkg: nagios-nrpe-server
