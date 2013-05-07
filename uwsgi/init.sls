{#
 Install uWSGI Web app server.
 #}
include:
  - git
  - nginx
  - pip
  - ruby
  - web
  - apt
  - python.dev

/etc/init/uwsgi.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/upstart.jinja2

uwsgitop:
  pip:
    - installed
    - require:
      - module: pip

uwsgi_build:
  pkg:
    - latest
    - names:
      - libxml2-dev
      - libxslt1-dev
    - require:
      - cmd: apt_sources
  git:
    - latest
    - name: {{ pillar['uwsgi']['repository'] }}
    - target: /usr/local/uwsgi
    - rev: {{ pillar['uwsgi']['version'] }}
    - require:
      - pkg: git
  file:
    - managed
    - name: /usr/local/uwsgi/buildconf/custom.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/buildconf.jinja2
    - require:
      - git: uwsgi_build
  cmd:
    - wait
    - name: python uwsgiconfig.py --clean; python uwsgiconfig.py --build custom
    - cwd: /usr/local/uwsgi
    - stateful: false
    - watch:
      - pkg: uwsgi_build
      - git: uwsgi_build
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
      - pkg: uwsgi_build
      - git: uwsgi_build
      - file: uwsgi_build

uwsgi_emperor:
  cmd:
    - wait
    - name: strip /usr/local/uwsgi/uwsgi
    - stateful: false
    - watch:
      - pkg: uwsgi_build
      - git: uwsgi_build
      - file: uwsgi_build
      - cmd: uwsgi_build
  service:
    - name: uwsgi
    - running
    - enable: True
    - require:
      - file: uwsgi_emperor
      - file: uwsgi_sockets
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
