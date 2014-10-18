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

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Dovecot: A POP3/IMAP server.
-#}
{%- from 'upstart/rsyslog.sls' import manage_upstart_log with context -%}
{% set ssl = salt['pillar.get']('dovecot:ssl', False) %}
include:
  - apt
  - dovecot.agent
  - postfix
  - rsyslog
{% if ssl %}
  - ssl
{% endif %}

{#- PID file owned by root, no need to manage #}

dovecot:
  pkg:
    - installed
    - pkgs:
      - dovecot-imapd
      - dovecot-pop3d
      - dovecot-ldap
      - dovecot-lmtpd
      - dovecot-managesieved
    - require:
      - cmd: apt_sources
      - pkg: postfix
  service:
    - running
    - order: 50
    - watch:
      - user: dovecot_user
      - user: dovecot-agent
      - file: /etc/dovecot/dovecot.conf
      - pkg: dovecot
      - file: /etc/dovecot/dovecot-ldap.conf.ext
      - file: /var/mail/vhosts/indexes
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}

{{ manage_upstart_log('dovecot') }}

{%- for user in ('dovecot', 'dovenull') %}
{{ user }}_user:
  user:
    - present
    - name: {{ user }}
    - shell: /bin/false
    - require:
      - pkg: dovecot
{%- endfor %}

{#- this setup uses only dovecot.conf config file, remove this dir for avoiding
    confusing #}
/etc/dovecot/conf.d:
  file:
    - absent
    - require:
      - pkg: dovecot
    - watch_in:
      - service: dovecot

/etc/dovecot/dovecot.conf:
  file:
    - managed
    - source: salt://dovecot/config.jinja2
    - template: jinja
    - mode: 400
    - user: dovecot
    - group: dovecot
    - require:
      - pkg: dovecot
      - user: dovecot-agent

/etc/dovecot/dovecot-ldap.conf.ext:
  file:
    - managed
    - source: salt://dovecot/ldap.jinja2
    - mode: 400
    - template: jinja
    - user: dovecot
    - group: dovecot
    - require:
      - pkg: dovecot

/var/mail/vhosts/indexes:
  file:
    - directory
    - user: dovecot-agent
    - makedirs: True
    - mode: 750
    - require:
      - user: dovecot-agent
