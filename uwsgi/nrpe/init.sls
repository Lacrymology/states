{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - bash
  - bash.nrpe
  - git.nrpe
  - nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - ruby.nrpe
  - sudo
  - sudo.nrpe
  - web
  - xml.nrpe

/etc/sudoers.d/nagios_uwsgi:
  file:
    - absent

/etc/sudoers.d/nrpe_uwsgi:
  file:
    - managed
    - template: jinja
    - source: salt://uwsgi/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo
    - require_in:
      - pkg: nagios-nrpe-server

/usr/local/bin/uwsgi-nagios.sh:
  file:
   - absent

/usr/lib/nagios/plugins/check_uwsgi_nostderr:
  file:
    - managed
    - template: jinja
    - source: salt://uwsgi/nrpe/nostderr_wrap.jinja2
    - mode: 550
    - user: www-data
    - group: www-data
    - require:
      - file: /usr/lib/nagios/plugins/check_uwsgi

/usr/lib/nagios/plugins/check_uwsgi:
  file:
    - managed
    - template: jinja
    - source: salt://uwsgi/nrpe/check.jinja2
    - mode: 550
    - user: www-data
    - group: www-data
    - require:
      - pkg: nagios-nrpe-server
      - user: web
      - file: bash

{%- call passive_check('uwsgi') %}
  - file: /usr/lib/nagios/plugins/check_uwsgi_nostderr
  - file: /etc/sudoers.d/nrpe_uwsgi
{%- endcall %}
