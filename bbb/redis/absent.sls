{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
{%- set version = "2.2.4" -%}

{{ opts['cachedir'] }}/bbb/redis:
  file:
    - absent

redis-server-{{ version }}:
  pkg:
    - purged
    - order: 1
