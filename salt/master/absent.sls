{#
 Uninstall a Salt Management Master (server)
 #}
include:
  - salt.api.absent

salt-master:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: salt-master

{% if salt['cmd.has_exec']('pip') %}
GitPython:
  pip:
    - removed
{% endif %}

{% for file in ('/var/log/upstart/salt-master.log', '/srv/salt', '/srv/pillar') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: salt-master
{% endfor %}
