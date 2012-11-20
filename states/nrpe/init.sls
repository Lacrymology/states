{# Nagios NRPE Agent #}

nagios-nrpe-server:
  pkg:
    - installed
    - names:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
  file:
    - managed
    - name: /etc/nagios/nrpe.d/000-nagios-servers.cfg
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
  service:
    - running
    - watch:
      - pkg: nagios-nrpe-server
      - file: nagios-nrpe-server
