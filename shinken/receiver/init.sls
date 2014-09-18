{#-
Copyright (c) 2013, Quan Tong Anh
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

Author: Quan Tong Anh <tonganhquan.net@gmail.com>
Maintainer: Quan Tong Anh <tonganhquan.net@gmail.com>

State for Shinken Receiver.

Shinken Receiver will receive the NSCA messages and queue them to be sent to the
Arbiter or Scheduler for processing.
-#}
{%- from 'shinken/init.sls' import shinken_install_module with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - shinken
{% if ssl %}
  - ssl
{% endif %}

shinken-receiver.py:
  file:
    - absent
    - name: /usr/local/shinken/bin/shinken-receiver.py

{%- call shinken_install_module(module_name='nsca', hash='7dd8c372864bce48eb204a1444ad2ebd') %}
- service: shinken-receiver
{%- endcall %}

shinken-receiver:
  file:
    - managed
    - name: /etc/init/shinken-receiver.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: receiver
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - file: /var/lib/shinken
      - file: /var/log/shinken
    - watch:
      - cmd: shinken
      - file: /etc/shinken/receiver.conf
      - file: shinken-receiver
      - user: shinken
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ pillar['shinken']['ssl'] }}
{% endif %}
{#- does not use PID, no need to manage #}

/etc/shinken/receiver.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: receiver
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken
