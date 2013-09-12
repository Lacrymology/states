{% set version = '3.7.0' %}
terracotta:
  file:
    - absent
    - name: /etc/init/terracotta.conf
    - require:
      - service: terracotta
  service:
    - dead
  user:
    - absent
    - require:
      - service: terracotta

/usr/local/terracotta-{{ version }}:
  file:
    - absent
    - name: /usr/local/terracotta-{{ version }}
    - require:
      - service: terracotta

/etc/terracotta.conf:
  file:
    - absent
    - require:
      - service: terracotta
