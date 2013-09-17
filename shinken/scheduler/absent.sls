{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
shinken-scheduler:
  file:
    - absent
    - name: /etc/init/shinken-scheduler.conf
    - require:
      - service: shinken-scheduler
  service:
    - dead

/etc/shinken/scheduler.conf:
  file:
    - absent
