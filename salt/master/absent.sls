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

{#
 Only during integration test, we don't want to wipe salt states and pillars.
 #}
{% if pillar['integration_test']|default(False) %}
{% for file in ('/srv/salt', '/srv/pillar') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: salt-master
{% endfor %}
{% endif %}

/var/log/upstart/salt-master.log:
  file:
    - absent
    - require:
      - service: salt-master
