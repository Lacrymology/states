include:
  - nrpe

/etc/nagios/nrpe.d/gsyslog.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://gsyslog/nrpe.jinja2

{# gsyslog depends on klogd to get kernel logs #}
klogd:
  pkg:
    - installed
  service:
    - running

gsyslog:
  pkg:
    - installed
    - names:
      - gsyslog
      - python-graypy
  file:
    - managed
    - name: /etc/gsyslogd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://gsyslog/config.jinja2
    - require:
      - pkg: gsyslog
      - pkg: python-graypy
  service:
    - running
    - name: gsyslogd
    - watch:
      - pkg: gsyslog
      - pkg: python-graypy
      - file: /etc/gsyslogd.conf
    - require:
      - service: klogd

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
