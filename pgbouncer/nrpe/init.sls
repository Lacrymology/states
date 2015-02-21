{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - postgresql
  - postgresql.nrpe
  - python.dev
  - rsyslog.nrpe
  - sudo

{{ passive_check('pgbouncer') }}

/etc/sudoers.d/nrpe_pgbouncer:
  file:
    - managed
    - source: salt://pgbouncer/nrpe/sudo.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: sudo
