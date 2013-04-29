{#
 Uninstall diamond
#}

diamond:
  service:
    - dead
    - enable: False

{% for filename in ('/etc/diamond', '/usr/local/diamond', '/etc/init/diamond.conf' %}
{{ filename }}:
  file:
    - absent
    - require:
      - service: diamond
{% endfor %}
