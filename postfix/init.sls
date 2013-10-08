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

An Email Server (SMTP Server).
-#}
{% set ssl = salt['pillar.get']('postfix:ssl', False) %}
include:
  - apt
  - mail
{% if ssl %}
  - ssl
{% endif %}

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
  service:
    - running
    - order: 50
    - watch:
      - pkg: postfix
      - file: /etc/postfix/master.cf
      - file: postfix
{% if ssl %}
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
{% endif %}

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://postfix/master.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - file_mode: 400
    - require:
      - pkg: postfix

{%- if salt['pillar.get']('postfix:virtual_mailbox', False) %}
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
    {% if salt['file.file_exists']('/etc/postfix/vmailbox.db') %}
    - wait
    - watch:
      - file: /etc/postfix/vmailbox
    {% else %}
      - file: /etc/postfix/vmailbox
    - run
    {% endif %}
{%- endif %}
