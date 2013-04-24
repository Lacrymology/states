{#
 Nagios NRPE check for Memcache
#}
include:
  - nrpe

/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://memcache/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/memcache.cfg
