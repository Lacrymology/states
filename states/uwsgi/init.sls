{# TODO: add support for http://projects.unbit.it/uwsgi/wiki/Carbon #}
{# TODO: add support for https://github.com/unbit/uwsgi/tree/master/plugins/graylog2 #}
{# http://lists.unbit.it/pipermail/uwsgi/2011-December/003152.html #}

include:
  - nrpe
  - git
  - nginx

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

uwsgi_build:
  pkg:
    - latest
    - names:
      - build-essential
      - python-dev
      - libxml2-dev
  git:
    - latest
    - name: git://github.com/unbit/uwsgi.git
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
    - name: python uwsgiconfig.py --build custom
    - cwd: /usr/local/uwsgi
    - stateful: false
    - watch:
      - pkg: uwsgi_build
      - git: uwsgi_build
      - file: uwsgi_build

uwsgi_sockets:
  file:
    - directory
    - name: /var/run/uwsgi
    - user: www-data
    - group: www-data
    - mode: 770
    - require:
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
      - pkg: nginx

/etc/nagios/nrpe.d/uwsgi.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/uwsgi.cfg
