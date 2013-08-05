{#- use this ID to make it conflict with python/init.sls #}
/etc/python:
  file:
    - absent
    - name: /etc/python/logging.conf
