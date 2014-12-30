{#-
 Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - elasticsearch.nrpe.instance
  - mongodb.nrpe
  - nrpe
  - rsyslog.nrpe
  - pysc.nrpe
  - python.nrpe
  - requests.nrpe
  - sudo.nrpe
{%- if salt['pillar.get']("__test__", False) %}
  - elasticsearch.nrpe
{%- endif %}

/usr/lib/nagios/plugins/check_new_logs.py:
  file:
    - managed
    - source: salt://graylog2/server/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-graylog2.server
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('graylog2.server') }}

extend:
  /usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
    file:
      - require:
        - file: nsca-graylog2.server
