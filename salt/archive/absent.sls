{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
salt_archive:
  user:
    - absent
    - require:
      - file: salt_archive
  file:
    - absent
    - name: /var/lib/salt_archive
