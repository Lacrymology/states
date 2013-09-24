{#-
 Uninstall VNC server
#}

{%- set user = salt['pillar.get']('tightvncserver:user', 'vnc') %}
{%- set home = "/home/" + user %}

tightvncserver:
  user:
    - absent
    - name: vnc
    - force: True
  pkg:
    - purged
    - require:
      - service: tightvncserver
  file:
    - absent
    - name: {{ home }}
  service:
    - dead

/etc/init/tightvncserver.conf:
  file:
    - absent
    - require:
      - service: tightvncserver

/etc/logrotate.d/tightvncserver:
  file:
    - absent

