{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Uninstall a DNS cache server
 -#}
pdnsd:
  pkg:
    - purged
    - require:
      - service: pdnsd
  service:
    - dead
    - enable: False

{% for file in ('default/pdnsd', 'pdnsd.conf') %}
/etc/{{ file }}:
  file:
    - absent
    - require:
      - pkg: pdnsd
{% endfor %}
