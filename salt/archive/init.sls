{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
salt_archive:
  user:
    - present
    - fullname: Salt Archive
    - shell: /bin/false
    - home: /var/lib/salt_archive
    - gid_from_name: True
    - createhome: False
  file:
    - directory
    - name: /var/lib/salt_archive
    - user: root
    - group: salt_archive
    - mode: 755
    - require:
      - user: salt_archive
