{#-
 Uninstall VNC server
#}

{%- set root_home = salt['user.info']('root')['home'] %}

tightvncserver:
  pkg:
    - purged
    - require:
      - service: tightvncserver
  file:
    - absent
    - name: {{ root_home }}/.vnc
  service:
    - dead

/etc/init.d/tightvncserver:
  file:
    - absent
    - require:
      - service: tightvncserver

tightvncserver_remove_tmp_files:
  cmd:
    - run
    - name: rm -rf .X1*
    - cwd: /tmp
    - user: root
    - require:
      - service: tightvncserver
