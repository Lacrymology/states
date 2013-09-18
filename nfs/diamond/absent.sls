{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com

 Turn off Diamond statistics for NFS
 -#}
/etc/diamond/collectors/NfsdCollector.conf:
  file:
    - absent
