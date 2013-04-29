{#
 Uninstall a simple Git source control management server.
 #}
git-server:
  user:
    - absent
    - name: git
{% if pillar['destructive_absent']|default(False) %}
    - purge: True
{% else %}
  file:
    - absent
    - name: /var/lib/git-server/.ssh
{% endif %}
