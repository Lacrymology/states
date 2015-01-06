{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Uninstall a Salt API REST server.
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('salt-api') }}

salt_api:
  group:
    - absent

{%- set external_auth = salt['pillar.get']('salt_api:external_auth', {}) %}
{%- for authen_system in external_auth %}
    {%- if authen_system == 'pam' %}
        {%- for user in external_auth[authen_system] %}
user_{{ user }}:
  user:
    - absent
    - name: {{ user }}
    - require_in:
      - group: salt_api
        {%- endfor %}
    {%- endif %}
{% endfor %}

extend:
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

/usr/lib/python2.7/dist-packages/saltapi:
  file:
    - absent
    - require:
      - pkg: salt-api

/etc/salt/master.d/ui.conf:
  file:
    - absent
    - require:
      - pkg: salt-api

/etc/salt/master.d/api.conf:
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

/etc/nginx/conf.d/salt-api.conf:
  file:
    - absent

salt-api-requirements:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/salt.api
