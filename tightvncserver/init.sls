{#-
 Install TightVNC
#}

{%- set wm = salt['pillar.get']('tightvncserver:wm', 'fluxbox') %}
{%- set root_home = salt['user.info']('root')['home'] %}

include:
  - apt
  - {{ wm }}

tightvncserver:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
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
