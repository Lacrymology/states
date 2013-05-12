{#
 Uninstall a Salt Management Master (server)
 #}
include:
  - salt.api.absent

salt-master:
  service:
    - dead
    - enable: False
  pkg:
    - purged
    - require:
      - service: salt-master

{% if salt['cmd.has_exec']('pip') %}
GitPython:
  pip:
    - removed
{% endif %}

/srv/salt:
  file:
    - absent
