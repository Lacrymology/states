{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
/var/lib/reprepro/salt/ubuntu:
  file:
    - absent

/etc/nginx/conf.d/salt_mirror_ppa.conf:
  file:
    - absent
