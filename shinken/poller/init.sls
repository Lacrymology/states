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

Shinken Poller state.

The poller daemon launches check plugins as requested by schedulers. When the
check is finished it returns the result to the schedulers. Pollers can be
tagged for specialized checks (ex. Windows versus Unix, customer A versus
customer B, DMZ) There can be many pollers for load-balancing or hot standby
spare roles.
-#}
{%- from 'shinken/init.sls' import shinken_install_module with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - apt
  - nrpe
  - shinken
  - ssl.dev
{% if ssl %}
  - ssl
{% endif %}

nagios-nrpe-plugin:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: nagios-plugins

shinken-poller.py:
  file:
    - absent
    - name: /usr/local/shinken/bin/shinken-poller.py

{%- if 'files_archive' in pillar %}
    {%- call shinken_install_module('booster-nrpe') %}
- source_hash: md5=667d7d941f3156a93f3396654ee631dc
    {%- endcall %}
{%- else %}
    {{ shinken_install_module('booster-nrpe') }}
{%- endif %}

shinken-poller:
  file:
    - managed
    - name: /etc/init/shinken-poller.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: poller
      max_filedescriptors: {{ salt['pillar.get']('shinken:poller_max_fd', 16384) }}
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - file: /var/lib/shinken
      - file: /var/run/shinken
      - pkg: nagios-nrpe-plugin
    - watch:
      - cmd: shinken
      - cmd: shinken-module-booster-nrpe
      - file: /etc/shinken/poller.conf
      - file: shinken-poller
      - user: shinken
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}

/etc/shinken/poller.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: poller
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken

extend:
  shinken:
    module:
      - watch:
        - pkg: ssl-dev
