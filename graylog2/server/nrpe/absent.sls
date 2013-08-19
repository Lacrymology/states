{#
 Remove NRPE check for Graylog2 Server
#}
/usr/lib/nagios/plugins/check_new_logs.py:
  file:
    - absent

/etc/nagios/nrpe.d/graylog2-server.cfg:
  file:
    - absent
