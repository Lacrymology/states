{#
 Uninstall a DNS cache server
 #}
pdnsd:
  pkg:
    - purged
    - require:
      - service: pdnsd
  service:
    - dead
    - enable: False

{% for file in ('default/pdnsd', 'pdnsd.conf') %}
/etc/:
  file:
    - absent
    - require:
      - pkg: pdnsd
{% endfor %}
