/etc/nginx/conf.d/shinken-web.conf:
  file:
    - absent

shinken-broker:
  file:
    - absent
    - name: /etc/init/shinken-broker.conf
    - require:
      - service: shinken-broker
  service:
    - dead

/etc/shinken/broker.conf:
  file:
    - absent
