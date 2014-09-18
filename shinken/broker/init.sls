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

Shinken Broker state.

The broker daemon exports and manages data from schedulers. The broker uses
modules exclusively to get the job done.
-#}
{%- from 'shinken/init.sls' import shinken_install_module with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - nginx
  - rsyslog
  - shinken
{% if ssl %}
  - ssl
{% endif %}
  - web

/etc/nginx/conf.d/shinken-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://shinken/broker/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web

shinken-broker.py:
  file:
    - absent
    - name: /usr/local/shinken/bin/shinken-broker.py

{#- install shinken modules for broker web ui #}
{%- if 'graphite_address' in pillar -%}
    {%- call shinken_install_module(module_name='graphite', hash='56b393c9970275327644123480ffd413') %}
- service: shinken-broker
    {%- endcall %}
    {%- call shinken_install_module(module_name='ui-graphite', hash='497dafa1036c84f2c5722fb557060c50') %}
- service: shinken-broker
    {%- endcall %}
{% endif %}

{%- call shinken_install_module(module_name='auth-cfg-password', hash='c91aef6581d2d4ef33cccd50bd16faf4') %}
- service: shinken-broker
{%- endcall %}

{%- call shinken_install_module(module_name='sqlitedb', hash='ef0bc27efbcadc4f9056a263cd698cbd') %}
- service: shinken-broker
{%- endcall %}

{%- call shinken_install_module(module_name='syslog-sink', hash='41acd03bc4f0579debc6b0402d257a9a') %}
- service: shinken-broker
{%- endcall %}

{%- call shinken_install_module(module_name='webui', hash='396be5667ca41b57d65239d7bd4b061a') %}
- service: shinken-broker
{%- endcall %}

shinken-broker:
  file:
    - managed
    - name: /etc/init/shinken-broker.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: broker
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - file: /var/log/shinken
      - file: /var/lib/shinken
    - watch:
      - cmd: shinken
      - cmd: shinken-module-pickle-retention-file-generic
      - file: /etc/shinken/broker.conf
      - file: shinken
      - file: shinken-broker
      - service: rsyslog
      - user: shinken
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ pillar['shinken']['ssl'] }}
{% endif %}
{#- does not use PID, no need to manage #}

/etc/shinken/broker.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: broker
    - require:
      - file: /etc/shinken
      - user: shinken

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/shinken-web.conf
{% if ssl %}
        - cmd: ssl_cert_and_key_for_{{ pillar['shinken']['ssl'] }}
{% endif %}
