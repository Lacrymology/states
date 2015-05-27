{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - local
  - rsyslog
  - ssh.common

{%- from 'ssh/common.sls' import root_home with context %}

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
{#- PID file owned by root, no need to manage #}

ssh_server_root_authorized_keys:
  file:
    - managed
    - name: {{ root_home() }}/.ssh/authorized_keys
    - mode: 400
    - contents: |
{%- for user in salt['pillar.get']('ssh:server:root_keys', {}) -%}
  {%- for key in salt['pillar.get']('ssh:server:root_keys:' ~ user, []) %}
        command="/usr/local/bin/root-shell-wrapper {{ user }}" {{ key }}
  {%- endfor %}
{%- endfor %}
    - require:
      - file: {{ root_home() }}/.ssh
      - file: /usr/local/bin/root-shell-wrapper

/usr/local/bin/root-shell-wrapper:
  file:
    - managed
    - source: salt://ssh/server/root-shell-wrapper.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local

/etc/rsyslog.d/ssh.conf:
  file:
{% if not salt['pillar.get']('debug', False) and salt['pillar.get']('shinken_pollers', []) %}
    - managed
    - template: jinja
    - source: salt://ssh/server/rsyslog.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
{% else %}
    - absent
{% endif %}
