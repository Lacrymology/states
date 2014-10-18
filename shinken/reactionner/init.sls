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

Shinken reactionner state.

The reactionner daemon issues notifications and launches event_handlers. This
centralizes communication channels with external systems in order to simplify
SMTP authorizations or RSS feed sources (only one for all hosts/services).
There can be many reactionners for load-balancing and spare roles
-#}
{%- from 'upstart/rsyslog.sls' import manage_upstart_log with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - rsyslog
  - shinken
{% if ssl %}
  - ssl
{% endif %}

shinken-reactionner:
  file:
    - managed
    - name: /etc/init/shinken-reactionner.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: reactionner
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - file: /var/lib/shinken
      - file: /var/run/shinken
    - watch:
      - cmd: shinken
      - file: /etc/shinken/reactionner.conf
      - user: shinken
      - file: shinken-reactionner
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ pillar['shinken']['ssl'] }}
{% endif %}
{#- does not use PID, no need to manage #}

{{ manage_upstart_log('shinken-reactionner') }}

/etc/shinken/reactionner.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: reactionner
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken
