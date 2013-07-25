{#
 Remove Nagios NRPE check for NFS
#}
/etc/nagios/nrpe.d/nfs.cfg:
  file:
    - absent
