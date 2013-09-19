{#-
 Uninstall VNC server
#}

{%- set root_home = salt['user.info']('root')['home'] %}

tightvncserver:
  pkg:
    - purged
  file:
    - absent
    - name: {{ root_home }}/.vnc

