{#
 Install an OpenSSH secure shell server
 #}
include:
  - apt

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
    - name: ssh
    - watch:
      - pkg: openssh-server
      - file: openssh-server

{% if 'root_keys' in pillar %}
{% for key in pillar['root_keys'] %}
ssh_server_root_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: root
    - enc: {{ pillar['root_keys'][key] }}
{% endfor -%}
{%- endif %}
