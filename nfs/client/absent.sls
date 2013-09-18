{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
/etc/default/nfs-common:
  file:
    - absent

nfs-common:
  pkg:
    - purged
