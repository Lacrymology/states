{#
 Nagios NRPE check for Denyhosts
#}
include:
  - nrpe
  - apt.nrpe
  - gsyslog.nrpe
  - denyhosts

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://denyhosts/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

/var/lib/denyhosts/allowed-hosts:
  file:
    - managed
    - source: salt://denyhosts/nrpe/allowed.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/denyhosts.cfg
  denyhosts:
    service:
      - watch:
        - file: /var/lib/denyhosts/allowed-hosts
