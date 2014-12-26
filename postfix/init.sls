{#-
Copyright (c) 2013, Hung Nguyen Viet
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

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- set ssl = salt['pillar.get']('postfix:ssl', False) -%}
{%- set spam_filter = salt['pillar.get']('postfix:spam_filter', False) %}
include:
{%- if spam_filter %}
    {%- if salt['pillar.get']('amavis:check_virus', True) %}
  - amavis.clamav
    {%- else %}
  - amavis
    {%- endif -%}
{%- endif %}
  - apt
  - mail
{%- if ssl %}
  - ssl
{%- endif %}
{%- if salt['pillar.get']('postfix:domains', [])|length > 0 %}
  - dovecot.agent

/var/mail/vhosts:
  file:
    - directory
    - user: dovecot-agent
    - require:
      - user: dovecot-agent
    - require_in:
      - service: postfix

/etc/postfix/vmailbox:
  file:
    - managed
    - source: salt://postfix/vmailbox.jinja2
    - template: jinja
    - mode: 400
    - user: postfix
    - group: postfix
    - require:
      - pkg: postfix

postmap /etc/postfix/vmailbox:
  cmd:
    - require:
      - pkg: postfix
      - file: /etc/postfix
    {% if salt['file.file_exists']('/etc/postfix/vmailbox.db') %}
    - wait
    - watch:
      - file: /etc/postfix/vmailbox
    {% else %}
      - file: /etc/postfix/vmailbox
    - run
    {% endif %}
{%- endif %}

apt-utils:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

postfix:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
      - pkg: apt-utils
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: postfix
  file:
    - managed
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - file_mode: 400
    - require:
      - pkg: postfix
      - file: /etc/postfix
  service:
    - running
    - order: 50
{%- if spam_filter %}
    - require:
      - service: amavis
    {%- if salt['pillar.get']('amavis:check_virus', True) %}
      - service: clamav-daemon
    {%- endif -%}
{%- endif %}
    - watch:
      - pkg: postfix
      - user: postfix
      - file: /etc/postfix/master.cf
      - file: /etc/postfix
      - file: postfix
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}

/etc/postfix:
  file:
    - directory
    - user: postfix
    - group: postfix
    - require:
      - pkg: postfix

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://postfix/master.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - mode: 400
    - require:
      - file: /etc/postfix

postfix_local_aliases:
  file:
    - managed
    - name: /etc/aliases
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - source: salt://postfix/aliases.jinja2
    - require:
      - pkg: postfix
  cmd:
    - wait
    - name: newaliases
    - watch:
      - file: postfix_local_aliases

{%- if salt['pillar.get']('postfix:virtual_aliases', False) %}
{# contains alias for email forwarding #}
postfix_virtual_aliases:
  file:
    - managed
    - name: /etc/postfix/virtual
    - template: jinja
    - mode: 400
    - user: postfix
    - group: postfix
    - contents: |
        {{ salt['pillar.get']('postfix:virtual_aliases', False) | indent(8) }}
    - require:
      - pkg: postfix
  cmd:
    {%- if salt['file.file_exists']('/etc/postfix/virtual.db') %}
    - wait
    {%- else %}
    - run
    {%- endif %}
    - name: postmap /etc/postfix/virtual
    - watch:
      - file: postfix_virtual_aliases
{%- else %}
postfix_virtual_aliases:
  file:
    - absent
    - name: /etc/postfix/virtual
    - require:
      - pkg: postfix

/etc/postfix/virtual.db:
  file:
    - absent
    - require:
      - pkg: postfix
{%- endif %}
