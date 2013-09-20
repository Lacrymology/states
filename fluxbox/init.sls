{#-
 Install Fluxbox - Windows Manager
#}

{%- set root_home = salt['user.info']('root')['home'] %}

include:
  - apt

fluxbox:
  pkg:
    - latest
    - pkgs:
      - eterm
      - fluxbox
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: {{ root_home }}/.fluxbox/menu
    - user: root
    - group: root
    - mode: 444
    - source: salt://fluxbox/menu.jinja2
    - template: jinja
    #- require:
      #- pkg: fluxbox
