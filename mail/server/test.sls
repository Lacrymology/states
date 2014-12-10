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
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - amavis
  - amavis.nrpe
  - amavis.diamond
  - amavis.clamav
  - clamav.nrpe
  - clamav.diamond
  - dovecot
  - dovecot.backup
  - dovecot.backup.diamond
  - dovecot.backup.nrpe
  - dovecot.diamond
  - dovecot.nrpe
  - mail.server.nrpe
  - openldap
  - openldap.diamond
  - openldap.nrpe
  - postfix.nrpe
  - postfix.diamond

{%- call test_cron() %}
- sls: amavis
- sls: amavis.nrpe
- sls: amavis.diamond
{# - sls: amavis.clamav this formula only extend this requirement fail #}
- sls: clamav.nrpe
- sls: clamav.diamond
- sls: dovecot
- sls: dovecot.backup
- sls: dovecot.backup.nrpe
- sls: dovecot.diamond
- sls: dovecot.nrpe
- sls: mail.server.nrpe
- sls: openldap
- sls: openldap.diamond
- sls: openldap.nrpe
- sls: postfix.nrpe
- sls: postfix.diamond
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        Amavis:
          amavis.sysUpTime.time: False
        Postfix:
          postfix.(recv|send).status.sent: True
        ProcessResources:
          {{ diamond_process_test('amavis') }}
          {{ diamond_process_test('postfix') }}
        UserScripts:
          postfix.queue_length: True
    - require:
      - sls: amavis
      - sls: amavis.diamond
      - sls: postfix
      - sls: postfix.diamond
      - monitoring: test
