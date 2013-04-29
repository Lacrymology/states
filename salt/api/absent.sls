{#
 Uninstall a Salt API REST server.
 #}
{# TODO: Support Nginx #}

salt_api:
  group:
    - absent
    - require:
{% for user in pillar['salt_master']['external_auth']['pam'] %}
      - user: user_{{ user }}
{% endfor %}

{# You need to set the password for each of those users #}
{% for user in pillar['salt_master']['external_auth']['pam'] %}
user_{{ user }}:
  user:
    - absent
{% endfor %}

salt-api:
  pkg:
    - purged
    - require:
      - service: salt-api
  pip:
    - removed
    - name: cherrypy
    - require:
      - pkg: salt-api
  file:
    - absent
    - name: /etc/init/salt-api.conf
    - require:
      - service: salt-api
  service:
    - dead
    - enable: False

/etc/salt/master.d/ui.conf:
  file:
    - absent
    - require:
      - pkg: salt-api

/usr/local/salt-ui:
  file:
    - absent

/etc/nginx/conf.d/salt.conf:
  file:
    - absent
