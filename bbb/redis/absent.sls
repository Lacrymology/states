{%- set version = "2.2.4" -%}

{{ opts['cachedir'] }}/bbb/redis:
  file:
    - absent

redis-server-{{ version }}:
  pkg:
    - purged
    - order: 1
