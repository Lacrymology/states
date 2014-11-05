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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
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

{%- from 'nrpe/passive.sls' import passive_absent with context %}
{{ passive_absent('postgresql.server') }}

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
