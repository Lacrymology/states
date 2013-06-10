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
