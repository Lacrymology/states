
/var/lib/reprepro/salt/ubuntu:
  file:
    - absent

/etc/nginx/conf.d/salt_mirror_ppa.conf:
  file:
    - absent
