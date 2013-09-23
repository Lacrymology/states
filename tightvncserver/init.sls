{#-
Install TightVNC
================

Mandatory Pillar
----------------

Optional Pillar
---------------
tightvncserver:
  wm:
  resolution:
  user: - user name will run vnc
  user_passwd: - password for user
  sudo: - make vnc user as sudoer. Default False

 tightvncserver:password - Password for vnc client login, it will be truncated if more than 8 characters

#}
{%- set wm = salt['pillar.get']('tightvncserver:wm', 'fluxbox') %}
{%- set user = salt['pillar.get']('tightvncserver:user', 'vnc') %}
{%- set user_passwd = salt['pillar.get']('tightvncserver:user_passwd', 'vnc') %}
{%- set home = "/home/" + user %}
{%- set vnc_passwd = salt['pillar.get']('tightvncserver:password', '12345678') %}

include:
  - apt
  - logrotate
  - {{ wm }}

tightvncserver_depends:
  pkg:
    - installed
    - name: xfonts-base
    - require:
      - cmd: apt_sources

tightvncserver:
  user:
    - present
    - name: {{ user }}
    - home: /home/{{ user }}
{%- if salt['pillar.get']('tightvncserver:sudo', False) %}
    - groups:
      - sudo
{%- endif %}
    - shell: /bin/bash
  module:
    - wait
    - name: shadow.set_password
    - m_name: {{ user }}
    - password: {{ salt['password.encrypt_shadow'](user_passwd) }}
    - watch:
      - user: tightvncserver
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: tightvncserver_depends
      - pkg: {{ wm }}
      - user: tightvncserver
  file:
    - managed
    - name: {{ home }}/.vnc/xstartup
    - mode: 550
    - user: {{ user }}
    - group: {{ user }}
    - source: salt://tightvncserver/xstartup.jinja2
    - template: jinja
    - require:
      - pkg: tightvncserver
    - context:
      wm: {{ wm }}
  cmd:
    - wait
    - name: echo -n `echo "{{ vnc_passwd }}" | tightvncpasswd -f` > .vnc/passwd
    - cwd: {{ home }}
    - user: {{ user }}
    - require:
      - file: tightvncserver
    - watch:
      - pkg: tightvncserver
  service:
    - running
    - enable: True
    - order: 50
    - sig: su vnc -c "/usr/bin/vncserver -depth 16 -geometry 1024x768 :1 "
    - require:
      - file: /etc/init.d/tightvncserver
      - pkg: tightvncserver
    - watch:
      - debconf: tightvncserver
      - cmd: tightvncserver
      - file: tightvncserver
      - file: {{ home }}/.vnc/passwd
  debconf:
    - set
    - name: x11-common
    - data:
        'x11-common/xwrapper/allowed_users': {'type': 'string', 'value': 'console' }
    - require:
      - pkg: debconf-utils
      - pkg: tightvncserver

/etc/init.d/tightvncserver:
  file:
    - managed
    - name: /etc/init.d/tightvncserver
    - user: root
    - group: root
    - mode: 555
    - source: salt://tightvncserver/upstart.jinja2
    - template: jinja
    - context:
      home: {{ home }}
      user: {{ user }}
    - require:
      - user: {{ user }}

{{ home }}/.vnc/passwd:
  file:
    - managed
    - user: {{ user }}
    - group: {{ user }}
    - mode: 600
    - watch:
      - cmd: tightvncserver
    - require:
      - user: tightvncserver

/etc/logrotate.d/tightvncserver:
  file:
    - managed
    - source: salt://tightvncserver/logrotate.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: logrotate
      - pkg: tightvncserver
    - context:
      home: {{ home }}

{%- if wm == "fluxbox" %}
{{ home }}/.fluxbox/menu:
  file:
    - managed
    - user: {{ user }}
    - group: {{ user }}
    - mode: 444
    - source: salt://fluxbox/menu.jinja2
    - template: jinja
    - require:
      - pkg: fluxbox
{%- endif %}
