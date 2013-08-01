{#
 Turn off Diamond statistics for NFS
 #}
/etc/diamond/collectors/NfsdCollector.conf:
  file:
    - absent
