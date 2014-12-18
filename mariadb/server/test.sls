{#-
Copyright (c) 2014, Quan Tong Anh
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

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - mariadb.server
  - mariadb.server.backup
  - mariadb.server.diamond
  - mariadb.server.nrpe

test:
  cmd:
    - run
    - name: /usr/local/bin/backup-mysql-all
    - require:
      - file: /usr/local/bin/backup-mysql-all
  diamond:
    - test
    - map:
        MySQL:
          {#- 
          Most of metrics values are zero because it's the derivative
          (http://en.wikipedia.org/wiki/Derivative) of the actual value.

          https://github.com/BrightcoveOS/Diamond/blob/v3.5/src/collectors/mysql/mysql.py#L420
          https://github.com/BrightcoveOS/Diamond/blob/v3.5/src/diamond/collector.py#L438
          -#}
          mysql.Threads_running: False
        ProcessResources:
          {{ diamond_process_test('mysql') }}
    - require:
      - sls: mariadb.server
      - sls: mariadb.server.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: mariadb.server
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
