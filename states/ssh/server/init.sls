{#
 Install an OpenSSH secure shell server
 #}
include:
  - diamond
  - nrpe
  - gsyslog

/etc/nagios/nrpe.d/ssh.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://ssh/server/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

openssh-server:
  pkg:
    - latest
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

ssh_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[sshd]]
        exe = ^\/usr\/sbin\/sshd,^\/usr\/lib\/sftp\-server

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

{% if not pillar['debug'] %}
/etc/gsyslog.d/ssh.conf:
  file:
    - managed
    - template: jinja
    - source: salt://ssh/server/gsyslog.jinja2
    - user: root
    - group: root
    - mode: 440
{% endif %}

extend:
{% if not pillar['debug'] %}
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/ssh.conf
{% endif %}
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ssh.cfg
