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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - roundcube
  - roundcube.backup
  - roundcube.backup.diamond
  - roundcube.backup.nrpe
  - roundcube.diamond
  - roundcube.nrpe

{%- call test_cron() %}
- sls: roundcube
- sls: roundcube.backup
- sls: roundcube.backup.diamond
- sls: roundcube.backup.nrpe
- sls: roundcube.diamond
- sls: roundcube.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 30
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: roundcube
    - additional:
      - roundcube.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-roundcube', zmempct=False) }}
    - require:
      - sls: roundcube
      - sls: roundcube.diamond
