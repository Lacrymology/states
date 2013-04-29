{#
 Uninstall Salt Minion (client)
 #}
salt-minion:
  file:
    - absent
    - name: /etc/salt/minion
    - require:
      - pkg: salt-minion
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - require:
      - service: salt-minion
  service:
    - dead
    - enabe: False
