{#
 Remove Nagios NRPE check for Sentry
#}
/etc/nagios/nrpe.d/sentry.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/sentry-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-sentry.cfg:
  file:
    - absent
