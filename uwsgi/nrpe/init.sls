{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Nagios NRPE check for uWSGI
-#}
include:
  - nrpe
  - sudo
  - git.nrpe
  - nginx.nrpe
  - pip.nrpe
  - ruby.nrpe
  - xml.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - web

/etc/nagios/nrpe.d/uwsgi.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
      - file: /usr/lib/nagios/plugins/check_uwsgi
      - file: /etc/sudoers.d/nrpe_uwsgi

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

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/uwsgi.cfg
