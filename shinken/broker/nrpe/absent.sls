{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{% for filename in ('broker', 'nginx') %}
/etc/nagios/nrpe.d/shinken-{{ filename }}.cfg:
  file:
    - absent
{% endfor %}
