{#
 Remove Nagios NRPE check for PostgreSQL Server
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/postgresql.cfg
        - file: /etc/nagios/nrpe.d/postgresql-diamond.cfg
{% endif %}

/etc/nagios/nrpe.d/postgresql-diamond.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - absent
