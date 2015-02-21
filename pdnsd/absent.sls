{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

pdnsd:
  pkg:
    - purged
    - require:
      - service: pdnsd
  service:
    - dead
    - enable: False
  user:
    - absent
    - require:
      - pkg: pdnsd

{% for file in ('default/pdnsd', 'pdnsd.conf') %}
/etc/{{ file }}:
  file:
    - absent
    - require:
      - pkg: pdnsd
{% endfor %}
