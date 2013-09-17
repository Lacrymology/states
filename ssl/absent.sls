{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Undo SSL state
 -#}
{% for name in pillar['ssl']|default([]) %}
/etc/ssl/{{ name }}:
  file:
    - absent
{% endfor %}

ssl-cert:
  pkg:
    - purged
