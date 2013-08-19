{#
 Uninstall a Salt API REST server.
 #}
{# TODO: Support Nginx #}

salt_api:
  group:
    - absent
{% for user in salt['pillar.get']('salt_master:external_auth:pam', []) %}
{% if loop.first %}
    - require:
{% endif %}
      - user: user_{{ user }}
{% endfor %}

{# You need to set the password for each of those users #}
{% for user in salt['pillar.get']('salt_master:external_auth:pam', []) %}
user_{{ user }}:
  user:
    - absent
{% endfor %}

salt-api:
  pkg:
    - purged
    - require:
      - service: salt-api
{#{% if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - name: cherrypy
    - require:
      - pkg: salt-api
{% endif %}#}
  file:
    - absent
    - name: /etc/init/salt-api.conf
    - require:
      - service: salt-api
  service:
    - dead

/etc/salt/master.d/ui.conf:
  file:
    - absent
    - require:
      - pkg: salt-api

/var/log/upstart/salt-api.log:
  file:
    - absent
    - require:
      - service: salt-api

/usr/local/salt-ui:
  file:
    - absent

/etc/nginx/conf.d/salt.conf:
  file:
    - absent

{{ opts['cachedir'] }}/salt-api-requirements.txt:
  file:
    - absent
