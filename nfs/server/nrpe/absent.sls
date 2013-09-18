{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for NFS
-#}
/etc/nagios/nrpe.d/nfs.cfg:
  file:
    - absent
