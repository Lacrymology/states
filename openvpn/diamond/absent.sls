{#
 Turn off Diamond statistics for OpenVPN
#}
/etc/diamond/collectors/OpenVPNCollector.conf:
  file:
    - absent
