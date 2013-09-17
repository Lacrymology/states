{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install an OpenSSH secure shell server
 -#}
include:
  - apt
  - rsyslog

openssh-server:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/ssh/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://ssh/server/config.jinja2
    - require:
      - pkg: openssh-server
  service:
    - running
    - enable: True
    - order: 50
    - name: ssh
    - require:
      - service: rsyslog
    - watch:
      - pkg: openssh-server
      - file: openssh-server

{% for key in salt['pillar.get']('root_keys', []) -%}
ssh_server_root_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: root
    - enc: {{ pillar['root_keys'][key] }}
{% endfor -%}
