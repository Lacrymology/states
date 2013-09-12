{#
 Setup a Salt API REST server.
 #}
include:
  - salt.master
  - git
  - local
  - nginx
  - pip
  - rsyslog
{% if pillar['salt_master']['ssl']|default(False) %}
  - ssl
{% endif %}

salt_api:
  group:
    - present

{% for user in pillar['salt_master']['external_auth']['pam'] %}
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
    - password: {{ salt['password.encrypt_shadow'](pillar['salt_master']['external_auth']['pam'][user]) }}
    - watch:
      - user: user_{{ user }}
{% endfor %}

/etc/salt/master.d/ui.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/api/config.jinja2
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: salt-master

salt-api-requirements:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-api-requirements.txt
    - source: salt://salt/api/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/salt-api-requirements.txt
    - watch:
      - file: salt-api-requirements
    - require:
      - module: pip
{%- set version = salt['pillar.get']('salt:version', '0.15.3') -%}
{%- set api_version = salt['pillar.get']('salt:api:version', '0.8.1') -%}
{%- set api_path = '{0}/pool/main/s/salt-api/salt-api_{1}_all.deb'.format(version, api_version) %}

salt-api:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - salt-api: {{ pillar['files_archive']|replace('file://', '') }}/mirror/salt/{{ api_path }}
{%- else %}
      - salt-api: http://saltinwound.org/ubuntu/{{ api_path }}
{%- endif %}
    - require:
      - pkg: salt-master
      - module: salt-api-requirements
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
    - enable: True
    - require:
      - service: rsyslog
    - watch:
      - file: salt-api
      - module: salt-api-requirements
      - file: /etc/salt/master.d/ui.conf
{%- if 'files_archive' in pillar %}
      - archive: salt-ui
{%- else %}
      - git: salt-ui
{%- endif %}

salt-ui:
{%- if 'files_archive' in pillar %}
  archive:
    - extracted
    - name: /usr/local
    - source: {{ pillar['files_archive'] }}/mirror/salt-ui-6e8eee0477fdb0edaa9432f1beb5003aeda56ae6.tar.gz
    - source_hash: md5=2b7e581d0134c5f5dc29b5fca7a2df5b
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/salt-ui/
    - require:
      - file: /usr/local
  {%- set salt_ui_module = 'archive' %}
{%- else %}
  git:
    - latest
    - rev: 6e8eee0477fdb0edaa9432f1beb5003aeda56ae6
    - name: git://github.com/saltstack/salt-ui.git
    - target: /usr/local/salt-ui/
    - require:
      - pkg: git
    {%- set salt_ui_module = 'git' %}
{%- endif %}
  file:
    - managed
    - name: /etc/nginx/conf.d/salt.conf
    - template: jinja
    - source: salt://salt/api/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - {{ salt_ui_module }}: salt-ui

salt-api:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - salt-api: {{ pillar['files_archive']|replace('file://', '') }}/mirror/salt/{{ api_path }}
{%- else %}
      - salt-api: http://saltinwound.org/ubuntu/{{ api_path }}
{%- endif %}
    - require:
      - pkg: salt-master
      - module: salt-api-requirements
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
      - file: /etc/salt/master.d/ui.conf
      - pkg: salt-api
      - {{ salt_ui_module }}: salt-ui

extend:
  nginx:
    service:
      - watch:
        - file: salt-ui
{% if pillar['salt_master']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['salt_master']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['salt_master']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['salt_master']['ssl'] }}/ca.crt
{% endif %}
  salt-master:
    service:
      - watch:
        - file: /etc/salt/master.d/ui.conf
