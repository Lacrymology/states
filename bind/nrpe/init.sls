{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - pip
  - resolver.nrpe
  - rsyslog.nrpe

pydns:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/pydns
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://bind/nrpe/requirements.jinja2
    - require:
      - file: {{ opts['cachedir'] }}/pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/pydns
    - require:
      - module: pip
    - watch:
      - file: pydns

/usr/lib/nagios/plugins/check_dns_caching.py:
  file:
    - managed
    - source: salt://bind/nrpe/check.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-bind
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('bind') }}
