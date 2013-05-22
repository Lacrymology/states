/usr/bin/mail:
  file:
    - symlink
    - target: /etc/alternatives/mail
    - force: True
    - user: root
    - group: root
    - mode: 775
