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
Maintainer: Bruno Clermont <patate@fastmail.cn>

Install a server or cluster of RabbitMQ message queue servers.

To properly use this state, the user monitor need to be changed
in WebUI to grant read access across all vhost.
as this is not yet implemented in salt.
-#}
include:
  - apt
  - erlang
  - logrotate
  - hostname
{%- if salt['pillar.get']('rabbitmq:ssl', False) %}
  - ssl
{%- endif %}
  - nginx

{% set master_id = pillar['rabbitmq']['cluster']['master'] %}

rabbitmq:
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/rabbitmq
    - password: "*"
    - enforce_password: True
    - gid_from_name: True

/var/lib/rabbitmq:
  file:
    - directory
    - user: rabbitmq
    - group: rabbitmq
    - mode: 700
    - require:
      - user: rabbitmq

{#
 Clustering requires the same cookie to be the same on all nodes.
 It need to be created BEFORE rabbitmq-server package is installed.
 If the cookie is changed while the daemon is running, it cannot be stopped
 using regular startup script and need to be manually killed.
#}

{%- set version = '3.1.2' %}
{%- set sub_version = version + '-1' %}
rabbitmq_erlang_cookie:
  file:
    - managed
    - name: /var/lib/rabbitmq/.erlang.cookie
    - template: jinja
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
    - source: salt://rabbitmq/cookie.jinja2
    - require:
      - file: /var/lib/rabbitmq

{%- if salt['pkg.version']('rabbitmq-server') not in ('', sub_version) %}
rabbitmq_old_version:
  pkg:
    - removed
    - name: rabbitmq-server
    - require_in:
      - pkg: rabbitmq-server
{%- endif %}

{#- does not use PID, no need to manage #}
rabbitmq-server:
  file:
    - directory
    - name: /etc/rabbitmq/rabbitmq.conf.d
    - mode: 550
    - require:
      - pkg: rabbitmq-server
  service:
    - running
    - enable: True
    - order: 50
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: beam{% if grains['num_cpus'] > 1 %}.smp{% endif %}
    - require:
      - pkg: rabbitmq-server
    - watch:
      - user: rabbitmq
      - file: rabbitmq-server
      - rabbitmq_plugin: rabbitmq-server
{% for node in pillar['rabbitmq']['cluster']['nodes'] %}
    {% if node != grains['id'] %}
      - host: host_{{ node }}
    {% endif %}
{% endfor %}
  rabbitmq_plugin:
    - enabled
    - name: rabbitmq_management
    - require:
      - pkg: rabbitmq-server
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - rabbitmq-server: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/rabbitmq-server_{{ sub_version }}_all.deb
{%- else %}
      - rabbitmq-server: http://www.rabbitmq.com/releases/rabbitmq-server/v{{ version }}/rabbitmq-server_{{ sub_version }}_all.deb
{%- endif %}
    - require:
      - pkg: erlang
      - cmd: apt_sources
      - pkg: logrotate
      - host: hostname
      - file: rabbitmq_erlang_cookie
{% if grains['id'] == master_id %}
{% set vhosts = salt['pillar.get']('rabbitmq:vhosts', []) %}
{% for vhost in vhosts %}
rabbitmq-vhost-{{ vhost }}:
  rabbitmq_user:
    - present
    - name: {{ vhost }}
    - password: {{ pillar['rabbitmq']['vhosts'][vhost] }}
    - force: True
    - require:
      - service: rabbitmq-server
  rabbitmq_vhost:
    - present
    - name: {{ vhost }}
    - user: {{ vhost }}
    - require:
      - rabbitmq_user: rabbitmq-vhost-{{ vhost }}
{% endfor %}

monitor_user:
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['monitor']['user'] }}
    - password: {{ salt['password.pillar']('rabbitmq:monitor:password') }}
    - force: True
    - tags:
      - monitoring
    - perms:
      - '/':
        - ""
        - ""
        - ".*"
{% for vhost in vhosts %}
  {%- if vhost != '/' %}
      - {{ vhost }}:
        - ""
        - ""
        - ".*"
  {%- endif %}
{%- endfor %}
    - require:
{% for vhost in vhosts %}
      - rabbitmq_vhost: rabbitmq-vhost-{{ vhost }}
{%- endfor %}
      - service: rabbitmq-server

admin_user:
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['management']['user'] }}
    - password: {{ salt['password.pillar']('rabbitmq:management:password') }}
    - force: True
    - require:
      - service: rabbitmq-server
    - tags:
      - administrator

rabbitmq_delete_guest:
  rabbitmq_user:
    - absent
    - name: guest
    - require:
      - service: rabbitmq-server
{% endif %}

{% if grains['id'] != master_id %}
join_rabbitmq_cluster:
  rabbitmq_cluster:
    - joined
    - host: {{ master_id }}
    - user: rabbit
    - require:
      - rabbitmq_plugin: rabbitmq-server
      - service: rabbitmq-server
{% endif %}

{% for node in pillar['rabbitmq']['cluster']['nodes'] -%}
    {% if node != grains['id'] -%}
host_{{ node }}:
  host:
    - present
    - name: {{ node }}
    - ip: {{ pillar['rabbitmq']['cluster']['nodes'][node]['private'] }}
    {% endif %}
{% endfor %}

/etc/nginx/conf.d/rabbitmq.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 400
    - source: salt://nginx/proxy.jinja2
    - require:
      - pkg: nginx
    - context:
      destination: http://127.0.0.1:15672
      ssl: {{ salt['pillar.get']('rabbitmq:ssl', False) }}
      hostnames: {{ pillar['rabbitmq']['hostnames'] }}
    - watch_in:
      - service: nginx

{% if salt['pillar.get']('rabbitmq:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ pillar['rabbitmq']['ssl'] }}
{% endif %}


/etc/apt/sources.list.d/www.rabbitmq.com-debian-testing.list:
  file:
    - absent
