{#
 Remove Nagios NRPE check for Graphite
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graphite.cfg
        - file: /etc/nagios/nrpe.d/graphite-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-graphite.cfg
{% endif %}

/etc/nagios/nrpe.d/graphite.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/graphite-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-graphite.cfg:
  file:
    - absent
