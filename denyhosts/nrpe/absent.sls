{#
 Remove Nagios NRPE check for Denyhosts
#}

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - absent

/var/lib/denyhosts/allowed-hosts:
  file:
    - absent
