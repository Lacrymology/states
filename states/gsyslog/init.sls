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
    - mode: 600
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
    - mode: 600
    - source: salt://gsyslog/logrotate.jinja2

gsyslog:
  pkg:
    - latest
    - name: libevent-dev
  virtualenv:
    - managed
    - name: /usr/local/gsyslog
    - requirements: salt://gsyslog/requirements.txt
    - require:
      - pkg: python-virtualenv
      - pkg: gsyslog
  file:
    - managed
    - name: /etc/gsyslogd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
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

/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://gsyslog/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
