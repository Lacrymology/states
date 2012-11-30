include:
  - virtualenv
  - nrpe

{# gsyslog depends on klogd to get kernel logs #}
sysklogd:
  pkg:
    - latest
    - names:
      - sysklogd
      - klogd
  service:
    - dead
    - enable: False

gsyslog_upstart:
  file:
    - managed
    - name: /etc/init/gsyslogd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/upstart.jinja2
    - require:
      - service: sysklogd

gsyslog_logrotate:
  file:
    - managed
    - name: /etc/logrotate.d/gsyslog
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/logrotate.jinja2

gsyslog_requirements:
  file:
    - managed
    - name: /usr/local/gsyslog/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/requirements.jinja2
    - require:
      - virtualenv: gsyslog

gsyslog:
  pkg:
    - latest
    - name: libevent-dev
  virtualenv:
    - managed
    - name: /usr/local/gsyslog
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - requirements: /usr/local/gsyslog/salt-requirements.txt
    - bin_env: /usr/local/gsyslog
    - require:
      - virtualenv: gsyslog
      - pkg: python-virtualenv
      - pkg: gsyslog
    - watch:
      - file: gsyslog_requirements
  file:
    - managed
    - name: /etc/gsyslogd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/config.jinja2
  service:
    - running
    - name: gsyslogd
    - watch:
      - file: gsyslog_upstart
      - virtualenv: gsyslog
      - file: gsyslog
    - require:
      - service: sysklogd
      - file: gsyslog_logrotate
      - module: gsyslog

/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://gsyslog/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
