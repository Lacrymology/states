{#
 Install uWSGI Web app server.
 #}
include:
  - nrpe
  - git
  - nginx
  - diamond
  - pip
  - sudo
  - ruby
  - web

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
      - pkg: python-pip

uwsgi_build:
  pkg:
    - latest
    - names:
      - build-essential
      - python-dev
      - libxml2-dev
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

{% if grains['virtual'] == 'kvm' and salt['file.file_exists']('/sys/kernel/mm/ksm/run') %}
diamond_ksm:
  file:
    - managed
    - name: /etc/diamond/collectors/KSMCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/basic_collector.jinja2
{% endif %}

/etc/sudoers.d/nagios_uwsgi:
  file:
    - managed
    - template: jinja
    - source: salt://uwsgi/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/local/bin/uwsgi-nagios.sh:
  file:
   - absent

/usr/lib/nagios/plugins/check_uwsgi:
  file:
    - managed
    - template: jinja
    - source: salt://uwsgi/nagios_check.jinja2
    - mode: 555
    - user: root
    - group: root

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

uwsgi_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi]]
        cmdline = ^\/usr\/local\/uwsgi\/uwsgi

/etc/nagios/nrpe.d/uwsgi.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/uwsgi.cfg
{% if grains['virtual'] == 'kvm' and salt['file.file_exists']('/sys/kernel/mm/ksm/run') %}
  diamond:
    service:
      - watch:
        - file: diamond_ksm
{% endif %}
