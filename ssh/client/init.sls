{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Configure an OpenSSH client.
-#}
include:
  - apt

{%- set root_home = salt['user.info']('root')['home'] %}

{{ root_home }}/.ssh:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

{%- for domain in salt['pillar.get']('ssh:known_hosts', []) %}
  {%- if pillar['ssh']['known_hosts'][domain] is string %}
ssh_{{ domain }}:
  file:
    - append
    - name: {{ root_home }}/.ssh/known_hosts
    - makedirs: True
    - text: |
        {{ pillar['ssh']['known_hosts'][domain] }}
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client
    - require_in:
      - file: known_hosts
  {%- endif %}
{%- endfor %}

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

{%- for hostname in salt['pillar.get']('ssh:keys', {}) -%}
    {%- for user in salt['pillar.get']('ssh:keys:' ~ hostname, {}) %}
/etc/ssh/keys/{{ user }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700
    - makedirs: True
    - require:
      - pkg: openssh-client

/etc/ssh/keys/{{ user }}/{{ hostname }}:
  file:
    - managed
    - contents: |
        {{ pillar['ssh']['keys'][hostname][user]['contents'] | indent(8) }}
    - user: {{ user }}
    - group: {{ user }}
    - mode: 400
    - require:
      - file: /etc/ssh/keys/{{ user }}
    {%- endfor -%}
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
{%- if salt['pillar.get']('deployment_key', False) %}
      - file: {{ root_home }}/.ssh/id_{{ pillar['deployment_key']['type'] }}

{%- set ssh_private_path = root_home + '/.ssh/id_' + pillar['deployment_key']['type'] %}
root_ssh_private_key:
  file:
    - managed
    - name: {{ ssh_private_path }}
    - contents: |
        {{ pillar['deployment_key']['contents'] | indent(8) }}
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: {{ root_home }}/.ssh

root_ssh_public_key:
  cmd:
    - wait
    - name: ssh-keygen -y -f {{ ssh_private_path }} > {{ ssh_private_path}}.pub
    - watch:
      - file: root_ssh_private_key
    - require:
      - pkg: openssh-client
{%- endif -%}
