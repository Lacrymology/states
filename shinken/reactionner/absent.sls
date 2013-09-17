{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
shinken-reactionner:
  file:
    - absent
    - name: /etc/init/shinken-reactionner.conf
    - require:
      - service: shinken-reactionner
  service:
    - dead

/etc/shinken/reactionner.conf:
  file:
    - absent
