{#
 Uninstall a MongoDB NoSQL server.
#}

mongodb_old_apt_repo:
  file:
    - name: /etc/apt/sources.list.d/downloads-distro.mongodb.org-repo_ubuntu-upstart-dist.list
    - absent

mongodb:
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - name: mongodb-10gen
    - require:
      - service: mongodb
  file:
    - absent
    - name: /etc/logrotate.d/mongodb
  service:
    - dead

{% if pillar['destructive_absent']|default(False) %}
/var/lib/mongodb:
  file:
    - absent
    - require:
      - pkg: mongodb
{% endif %}

{% for log in ('mongodb', 'upstart/mongodb.log') %}
/var/log/{{ log }}:
  file:
    - absent
    - pkg:
      - pkg: mongodb
{% endfor %}
