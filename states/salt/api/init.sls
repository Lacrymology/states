include:
  - salt.master
  - git
  - nginx
  - diamond
  - nrpe
{% if pillar['salt_master']['ssl']|default(False) %}
  - ssl
{% endif %}

salt_api:
  group:
    - present

{# You need to set the password for each of those users #}
{% for user in pillar['salt_master']['external_auth']['pam'] %}
user_{{ user }}:
  user:
    - present
    - groups:
      - salt_api
    - home: /home/{{ user }}
    - shell: /bin/false
    - require:
      - group: salt_api
{% endfor %}

/etc/salt/master.d/ui.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/api/config.jinja2
    - user: root
    - group: root
    - mode: 400
    - context: {{ pillar['salt_master'] }}
{% if not 'ssl' in pillar['salt_master'] and not salt['file.file_exists']("/etc/pki/tls/certs/" + pillar['salt_master']['hostname'] + ".crt") %}
  module:
    - wait
    - name: tls.create_self_signed_cert
    - tls_dir: tls
    - CN: {{ pillar['salt_master']['hostname'] }}
    {# 10 years #}
    - days: {{ 365 * 10 }}
    - watch:
      - file: /etc/salt/master.d/ui.conf
{% endif %}

salt-api:
  pkg:
    - installed
    - require:
      - pkg: salt-master
      - pip: salt-api
  pip:
    - installed
    - name: cherrypy
  file:
    - managed
    - name: /etc/init/salt-api.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/api/upstart.jinja2
  service:
    - running
    - watch:
      - file: salt-api
      - pip: salt-api
      - git: salt-ui
      - file: /etc/salt/master.d/ui.conf

salt-ui:
  git:
    - latest
    - rev: {{ pillar['salt_master']['ui'] }}
    - name: git://github.com/saltstack/salt-ui.git
    - target: /usr/local/salt-ui/
  file:
    - managed
    - name: /etc/nginx/conf.d/salt.conf
    - template: jinja
    - source: salt://salt/api/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - context: {{ pillar['salt_master'] }}

/etc/nagios/nrpe.d/salt-api.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/api/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

salt_api_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt.api]]
        name = ^salt\-api

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-api.cfg
  nginx:
    service:
      - watch:
        - file: salt-ui
{% if pillar['salt_master']['ssl']|default(False) %}
    {% for filename in ('chained_ca.crt', 'server.pem', 'ca.crt') %}
        - file: /etc/ssl/{{ pillar['salt_master']['ssl'] }}/{{ filename }}
    {% endfor %}
{% endif %}
  salt-master:
    service:
      - watch:
        - file: /etc/salt/master.d/ui.conf
