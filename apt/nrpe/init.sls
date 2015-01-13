{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nrpe

/usr/lib/nagios/plugins/check_apt-rc.py:
  file:
    - managed
    - source: salt://apt/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-apt
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('apt') }}
