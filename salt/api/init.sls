{#
 Setup a Salt API REST server.
 #}
include:
  - salt.master
  - git
  - apt
  - nginx
  - pip
  - salt
  - gsyslog
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
    - pkgs: ''
    - requirements: {{ opts['cachedir'] }}/salt-api-requirements.txt
    - watch:
      - file: salt-api-requirements
    - require:
      - module: pip

salt-api:
  pkg:
    - installed
    - require:
      - pkg: salt-master
      - module: salt-api-requirements
      - apt_repository: salt
      - cmd: apt_sources
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
      - service: gsyslog
    - watch:
      - file: salt-api
      - module: salt-api-requirements
      - file: /etc/salt/master.d/ui.conf
{%- if 'file_proxy' in pillar %}
      - archive: salt-ui
{%- else %}
      - git: salt-ui
{%- endif %}

salt-ui:
{%- if 'file_proxy' in pillar %}
  archive:
    - extracted
    - name: /usr/local
    - source: {{ pillar['file_proxy'] }}/salt-ui/6e8eee0477fdb0edaa9432f1beb5003aeda56ae6.tar.gz
    - source_hash: md5=2b7e581d0134c5f5dc29b5fca7a2df5b
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/salt-ui/
{%- else %}
  git:
    - latest
    - rev: 6e8eee0477fdb0edaa9432f1beb5003aeda56ae6
    - name: git://github.com/saltstack/salt-ui.git
    - target: /usr/local/salt-ui/
    - require:
      - pkg: git
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
