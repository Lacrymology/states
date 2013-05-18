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

{% for file in ('/srv/salt', '/srv/pillar', '/var/log/upstart/salt-master.log') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: salt-master
{% endfor %}
