{#
 Remove Nagios NRPE check for jenkins
#}
/etc/nagios/nrpe.d/jenkins-nginx.cfg:
  file:
    - absent
