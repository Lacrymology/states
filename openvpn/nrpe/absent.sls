{#
 Remove Nagios NRPE check for OpenVPN
#}
/etc/nagios/nrpe.d/openvpn.cfg:
  file:
    - absent
