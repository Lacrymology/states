{#
 Remove Nagios NRPE check for tomcat
#}
/etc/nagios/nrpe.d/tomcat.cfg:
  file:
    - absent
