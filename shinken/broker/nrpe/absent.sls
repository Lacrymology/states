{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
{% for filename in ('broker', 'nginx') %}
/etc/nagios/nrpe.d/shinken-{{ filename }}.cfg:
  file:
    - absent
{% endfor %}
