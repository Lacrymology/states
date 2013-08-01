{#
 Nagios NRPE check for ProFTPd
#}
include:
  - nrpe
  - apt.nrpe
  - postgresql.server.nrpe
  - web
  - rsyslog.nrpe

/etc/nagios/nrpe.d/proftpd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://proftpd/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
      - user: web

/etc/nagios/nrpe.d/postgresql-proftpd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: proftpd
      password: {{ pillar['proftpd']['password'] }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/proftpd.cfg
        - file: /etc/nagios/nrpe.d/postgresql-proftpd.cfg
