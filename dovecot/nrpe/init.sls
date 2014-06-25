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

Nagios NRPE check for Dovecot.
-#}
{%- set ssl = salt['pillar.get']('dovecot:ssl', False) %}
{%- from 'nrpe/passive.sls' import passive_check with context %}
{%- from 'openldap/init.sls' import ldap_adduser with context %}
include:
  - apt.nrpe
  - dovecot
  - nrpe
  - postfix.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}
  - openldap
  - openldap.nrpe

{{ passive_check('dovecot') }}

{%- if salt['pillar.get']('mail:check_mail_stack', False) %}
dovecot_check_mail_stack:
  file:
    - managed
    - name: /usr/local/nagios/salt-check-mail-stack-requirements.txt
    - source: salt://dovecot/nrpe/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/salt-check-mail-stack-requirements.txt
    - watch:
      - file: dovecot_check_mail_stack

{%- set username = salt['pillar.get']('mail:check_mail_stack:username') %}
{%- set mailname = pillar['mail']['mailname'] %}
{%- set mailaddr = username + '@' + mailname %}
{%- set password = pillar['ldap']['data'][mailname][username]['passwd'] %}

dovecot_add_spam_mailbox_for_check_user:
  cmd:
    - wait
    - name: doveadm mailbox create -u {{ mailaddr }} spam
    - watch:
      - file: dovecot_check_mail_stack
    - require:
      - service: dovecot
      - file: openldap_formula_interface

/etc/nagios/check_mail_stack.yml:
  file:
    - managed
    - source: salt://dovecot/nrpe/check_mail_stack.yml
    - user: nagios
    - group: nagios
    - mode: 440
    - template: jinja
    - context:
        username: {{ mailaddr }}
        password: {{ password }}
    - require:
      - pkg: nagios-nrpe-server

/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
    - managed
    - source: salt://dovecot/nrpe/check_mail_stack.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - module: dovecot_check_mail_stack
      - pkg: nagios-nrpe-server
      - file: /etc/nagios/check_mail_stack.yml
{%- endif %}
