{#
 Nagios NRPE check for uWSGI
#}
include:
  - nrpe
  - sudo
  - git.nrpe
  - nginx.nrpe
  - pip.nrpe
  - ruby.nrpe
  - xml.nrpe
  - python.dev.nrpe
  - gsyslog.nrpe
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
