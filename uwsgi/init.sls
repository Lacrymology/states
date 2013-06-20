{#
 Install uWSGI Web app server.
 This build come with only Python support.

 To turn on Ruby support, include uwsgi.ruby instead of this file.
 For PHP include uwsgi.php instead.
 You can include both uwsgi.php and uwsgi.ruby.
 #}
include:
  - git
  - nginx
  - pip
  - web
  - xml
  - python.dev
  - gsyslog

/etc/init/uwsgi.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/upstart.jinja2

uwsgi_build:
{%- if 'files_archive' in pillar -%}
  {%- set uwsgi_download_requirement = "archive" %}
  archive:
    - extracted
    - name: /usr/local
    - source: {{ pillar['files_archive'] }}/uwsgi/1.4.3-patched.tar.gz
    - source_hash: md5=7e906d84fd576bccd1a3bb7ab308ec3c
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/uwsgi
{%- else -%}
  {%- set uwsgi_download_requirement = "git" %}
  git:
    - latest
    - name: git://github.com/bclermont/uwsgi.git
    - rev: 1.4.3-patched
    - target: /usr/local/uwsgi
    - require:
      - pkg: git
{%- endif %}
  file:
    - managed
    - name: /usr/local/uwsgi/buildconf/custom.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/buildconf.jinja2
    - context:
      python: True
    - require:
      - {{ uwsgi_download_module }}: uwsgi_build
  cmd:
    - wait
    - name: python uwsgiconfig.py --clean; python uwsgiconfig.py --build custom
    - cwd: /usr/local/uwsgi
    - stateful: false
    - watch:
      - pkg: xml-dev
      - {{ uwsgi_download_module }}: uwsgi_build
      - file: uwsgi_build
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
      - {{ uwsgi_download_module }}: uwsgi_build
      - file: uwsgi_build

uwsgi_emperor:
  cmd:
    - wait
    - name: strip /usr/local/uwsgi/uwsgi
    - stateful: false
    - watch:
      - {{ uwsgi_download_module }}: uwsgi_build
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
