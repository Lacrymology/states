{#
 Remove Nagios NRPE check for Sentry
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/sentry.cfg
        - file: /etc/nagios/nrpe.d/sentry-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-sentry.cfg
{% endif %}

/etc/nagios/nrpe.d/sentry.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/sentry-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-sentry.cfg:
  file:
    - absent
