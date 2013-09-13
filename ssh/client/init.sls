{#
 Configure an OpenSSH client

Optional Pillar
==============

ssh:
  known_hosts:
    git.robotinfra.com:
      fingerprint: c9:fb:62:8b:d3:b6:c8:7d:33:6b:65:9f:e2:9d:a2:71
      port: 22022

#}
include:
  - apt

{% set root_home = salt['user.info']('root')['home'] %}

{{ root_home }}/.ssh:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

bitbucket.org:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client

github.com:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client

{%- for domain in salt['pillar.get']('ssh:known_hosts', []) %}
{{ knownhost(domain, pillar['ssh']['known_hosts'][domain]['fingerprint'], 'root', pillar['ssh']['known_hosts'][domain]['port']) }}
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client
    - require_in:
      - ssh_known_hosts: github.com
      - ssh_known_hosts: bitbucket.org
{%- endfor %}

openssh-client:
  file:
    - managed
    - name: /etc/ssh/ssh_config
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://ssh/client/config.jinja2
    - require:
      - pkg: openssh-client
  pkg:
    - latest
    - require:
      - cmd: apt_sources
{% if pillar['deployment_key']|default(False) %}
      - file: {{ root_home }}/.ssh/id_{{ pillar['deployment_key']['type'] }}

root_ssh_private_key:
  file:
    - managed
    - name: {{ root_home }}/.ssh/id_{{ pillar['deployment_key']['type'] }}
    - contents: |
        {{ pillar['deployment_key']['contents'] | indent(8) }}
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: {{ root_home }}/.ssh
{% endif %}

{%- macro knownhost(domain, fingerprint, user, port='22') %}
{{ user }}_{{ domain }}:
  ssh_known_hosts:
    - name: {{ domain }}
    - present
    - user: {{ user }}
    - fingerprint: {{ fingerprint }}
    - port: {{ port }}
{%- endmacro %}
