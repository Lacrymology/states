{#
 Uninstall an OpenSSH secure shell server
 #}
openssh-server:
  pkg:
    - purged
    - require:
      - service: openssh-server
  file:
    - absent
    - name: /etc/ssh/sshd_config
    - require:
      - pkg: openssh-server
  service:
    - dead
    - enable: False
    - name: ssh

{% for key in salt['pillar.get']('root_keys', []) %}
ssh_server_root_{{ key }}:
  ssh_auth:
    - absent
    - name: {{ key }}
    - user: root
    - enc: {{ pillar['root_keys'][key] }}
{% endfor -%}
