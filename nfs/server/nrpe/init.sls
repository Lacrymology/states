{#
 Nagios NRPE check for NFS
#}
include:
  - nrpe
  - apt.nrpe

/etc/nagios/nrpe.d/nfs.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nfs/server/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/nfs.cfg
