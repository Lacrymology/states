{#
 Install uWSGI Web app server.
 #}
include:
  - git
  - nginx
  - pip
  - ruby
  - web
  - xml
  - python.dev
  - gsyslog
{% if 'roundcube' in pillar %}
  - uwsgi.php
{% endif %}

/etc/init/uwsgi.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/upstart.jinja2


uwsgi_build:
{% if 'file_proxy' in pillar %}
  archive:
    - extracted
    - name: /usr/local
    - source: {{ pillar['file_proxy'] }}/uwsgi/1.4.3-patched.tar.gz
    - source_hash: md5=7e906d84fd576bccd1a3bb7ab308ec3c
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/uwsgi
{% else %}
  git:
    - latest
    {#- name: {{ pillar['uwsgi']['repository'] }}#}
    {#- rev: {{ pillar['uwsgi']['version'] }}#}
    - name: git://github.com/bclermont/uwsgi.git
    - rev: 1.4.3-patched
    - target: /usr/local/uwsgi
    - require:
      - pkg: git
{% endif %}
  file:
    - managed
    - name: /usr/local/uwsgi/buildconf/custom.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/buildconf.jinja2
    - require:
{% if 'file_proxy' in pillar %}
      - archive: uwsgi_build
{% else %}
      - git: uwsgi_build
{% endif %}
  cmd:
    - wait
    - name: python uwsgiconfig.py --clean; python uwsgiconfig.py --build custom
    - cwd: /usr/local/uwsgi
    - stateful: false
    - watch:
      - pkg: xml-dev
{% if 'file_proxy' in pillar %}
      - archive: uwsgi_build
{% else %}
      - git: uwsgi_build
{% endif %}
      - file: uwsgi_build
      - pkg: ruby
      - pkg: python-dev

uwsgi_sockets:
  file:
    - directory
    - name: /var/lib/uwsgi
    - user: www-data
    - group: www-data
    - mode: 770
    - require:
      - user: web
      - cmd: uwsgi_build
{% if 'file_proxy' in pillar %}
      - archive: uwsgi_build
{% else %}
      - git: uwsgi_build
{% endif %}
      - file: uwsgi_build

uwsgi_emperor:
  cmd:
    - wait
    - name: strip /usr/local/uwsgi/uwsgi
    - stateful: false
    - watch:
{% if 'file_proxy' in pillar %}
      - archive: uwsgi_build
{% else %}
      - git: uwsgi_build
{% endif %}
      - file: uwsgi_build
      - cmd: uwsgi_build
  service:
    - name: uwsgi
    - running
    - enable: True
    - require:
      - file: uwsgi_emperor
      - file: uwsgi_sockets
      - service: gsyslog
    - watch:
      - cmd: uwsgi_emperor
      - file: /etc/init/uwsgi.conf
  file:
    - directory
    - name: /etc/uwsgi
    - user: www-data
    - group: www-data
    - mode: 550
    - require:
      - user: web
