{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Configure an OpenSSH client

Optional Pillar
==============

ssh:
  known_hosts:
    git.robotinfra.com:
      fingerprint: c9:fb:62:8b:d3:b6:c8:7d:33:6b:65:9f:e2:9d:a2:71
      port: 22022

-#}
include:
  - apt

{%- set root_home = salt['user.info']('root')['home'] -%}

{%- macro knownhost(domain, fingerprint, user, port='22') %}
{{ user }}_{{ domain }}:
  ssh_known_hosts:
    - name: {{ domain }}
    - present
    - user: {{ user }}
    - fingerprint: {{ fingerprint }}
    - port: {{ port }}
{%- endmacro %}

{{ root_home }}/.ssh:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

known_hosts:
  file:
    - append
    - name: {{ root_home }}/.ssh/known_hosts
    - makedirs: True
    - text: |
        github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
        bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client

{%- for domain in salt['pillar.get']('ssh:known_hosts', []) %}
{{ knownhost(domain, pillar['ssh']['known_hosts'][domain]['fingerprint'], 'root', pillar['ssh']['known_hosts'][domain]['port']) }}
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client
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
{%- if pillar['deployment_key']|default(False) %}
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
{%- endif -%}
