shinken-arbiter:
  file:
    - absent
    - name: /etc/init/shinken-arbiter.conf
    - require:
      - service: shinken-arbiter
  service:
    - dead

/etc/shinken/arbiter.conf:
  file:
    - absent
