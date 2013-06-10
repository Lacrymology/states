{% for filename in ('broker', 'nginx') %}
/etc/nagios/nrpe.d/shinken-{{ filename }}.cfg:
  file:
    - absent
{% endfor %}
