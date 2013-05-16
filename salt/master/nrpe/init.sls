{#
 Nagios NRPE check for Salt Master
#}
include:
  - nrpe
  - git.nrpe
  - ssh.client.nrpe
  - pip.nrpe
  - python.dev.nrpe
  - apt.nrpe
  - gsyslog.nrpe

/etc/nagios/nrpe.d/salt-master.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/master/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-master.cfg
