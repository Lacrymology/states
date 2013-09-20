{#-
Install TightVNC
================

Mandatory Pillar
----------------
tightvncserver:
  password:

Optional Pillar
---------------
tightvncserver:
  wm:
  resolution:

 tightvncserver:password Password for login, it will be truncated if more than 8 characters


 This command with generatevnc password
 echo -n `echo "12345678" | tightvncpasswd -f` > ~/.vnc/passwd
#}
{%- set wm = salt['pillar.get']('tightvncserver:wm', 'fluxbox') %}
{%- set root_home = salt['user.info']('root')['home'] %}
{%- set passwd = salt['pillar.get']('tightvncserver:password', '12345678') %}

include:
  - apt
  - {{ wm }}

tightvncserver_depends:
  pkg:
    - installed
    - name: xfonts-base
    - require:
      - cmd: apt_sources

tightvncserver:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: tightvncserver_depends
      - pkg: {{ wm }}
  file:
    - managed
    - name: {{ root_home }}/.vnc/xstartup
    - mode: 544
    - user: root
    - group: root
    - source: salt://tightvncserver/xstartup.jinja2
    - template: jinja
    - require:
      - pkg: tightvncserver
    - context:
      wm: {{ wm }}
  cmd:
    - wait
    - name: echo -n `echo "{{ passwd }}" | tightvncpasswd -f` > .vnc/passwd
    - cwd: {{ root_home }}
    - user: root
    - require:
      - file: tightvncserver
    - watch:
      - pkg: tightvncserver
  service:
    - running
    - enabled: True
    - order: 50
    - require:
      - file: /etc/init.d/tightvncserver
      - pkg: tightvncserver
    - watch:
      - cmd: tightvncserver
      - file: tightvncserver
      - file: /etc/X11/Xwrapper.config
      - file: {{ root_home }}/.vnc/passwd

/etc/init.d/tightvncserver:
  file:
    - managed
    - name: /etc/init.d/tightvncserver
    - user: root
    - group: root
    - mode: 550
    - source: salt://tightvncserver/upstart.jinja2
    - template: jinja

{{ root_home }}/.vnc/passwd:
  file:
    - managed
    - user: root
    - group: root
    - mode: 600
    - watch:
      - cmd: tightvncserver

/etc/X11/Xwrapper.config:
  file:
    - managed
    - mode: 444
    - user: root
    - group: root
    - source: salt://tightvncserver/config.jinja2
    - template: jinja
    - require:
      - pkg: tightvncserver
