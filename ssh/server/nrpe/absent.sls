{#
 Remove Nagios NRPE check for OpenSSH Server
#}
/etc/nagios/nrpe.d/ssh.cfg:
  file:
    - absent
