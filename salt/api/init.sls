{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- set ssl = salt['pillar.get']('salt_api:ssl', False) %}

include:
  - git
  - local
  - nginx
  - pip
  - rsyslog
  - salt.master
  - salt.minion.deps
{% if ssl %}
  - ssl
{% endif %}

salt_api:
  group:
    - present

{%- set external_auth = salt['pillar.get']('salt_api:external_auth', {}) %}
{%- for authen_system in external_auth %}
    {%- if authen_system == 'pam' %}
        {%- for user in external_auth[authen_system] %}
user_{{ user }}:
  user:
    - present
    - name: {{ user }}
    - groups:
      - salt_api
    - home: /home/{{ user }}
    - shell: /bin/false
    - require:
      - group: salt_api
  module:
    - wait
    - name: shadow.set_password
    - m_name: {{ user }}
    - password: {{ salt['password.encrypt_shadow'](external_auth[authen_system][user]['password']) }}
    - watch:
      - user: user_{{ user }}
        {%- endfor %}
    {%- endif %}
{%- endfor %}

/etc/salt/master.d/api.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/api/config.jinja2
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: salt-master
    - watch_in:
      - service: salt-master

salt-api-requirements:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/salt.api
    - source: salt://salt/api/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/salt.api
    - watch:
      - file: salt-api-requirements

/etc/nginx/conf.d/salt-api.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/api/nginx.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - context:
        appname: salt_api
        root: /usr/local/salt-ui
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

{#- PID file owned by root, no need to manage #}
salt-api:
  file:
    - managed
    - name: /etc/init/salt-api.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/api/upstart.jinja2
    - require:
      - pkg: salt-api
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
    - watch:
      - file: salt-api
      - module: salt-api-requirements
      - file: /etc/salt/master.d/api.conf
      - pkg: salt-api
  pkg:
    - installed
    - require:
      - pkg: salt-master
      - module: salt-api-requirements

salt_api_patch_post_empty_body_23404:
  file:
    - patch
    - name: /usr/lib/python2.7/dist-packages/salt/netapi/rest_cherrypy/app.py
    - hash: md5=148e640f3da21453c4e6ae316baa6896
    - source: salt://salt/api/cherrypy.patch
    - watch_in:
      - service: salt-api
    - require:
      - pkg: salt-api
      - pkg: salt_minion_deps

{{ manage_upstart_log('salt-api') }}

{% if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
