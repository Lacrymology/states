{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
nagios-nrpe-plugin:
  pkg:
    - purged

shinken-poller:
  file:
    - absent
    - name: /etc/init/shinken-poller.conf
    - require:
      - service: shinken-poller
  service:
    - dead

/etc/shinken/poller.conf:
  file:
    - absent
