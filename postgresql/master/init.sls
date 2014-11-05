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

For setup a postgresql cluster, create overstate.sls at top level of states, with
content like below::

  master:
    match: 'pgmaster'
    sls:
      - postgresql.server.master

  standby:
    match: '*standby'
    sls:
      - postgresql.server.standby
    require:
      - master

See document for more:
https://salt.readthedocs.org/en/latest/ref/states/overstate.html

match: to match the minion-id that will run state specified in sls
sls: list of states to run on matched minions
require: require other "over" state run before it. In above example,
  sls postgresql.server.master will be ran on minion that have id 'pgmaster'
  then sls postgresql.server.standby will run on all minion that match
  '*standby'.
Master servers need to setup before standby servers to provide basebackup for
standby servers.
-#}
include:
  - postgresql.server

{%- set version="9.2" %}
extend:
  postgresql:
    file:
      - context:
        version: {{ version }}
        role: master

/etc/postgresql/9.2/main/pg_hba.conf:
  file:
    - managed
    - template: jinja
    - source: salt://postgresql/master/pg_hba.jinja2
    - user: postgres
    - group: postgres
    - mode: 440
    - require:
      - pkg: postgresql
    - watch_in:
      - service: postgresql

replication_agent:
  postgres_user:
    - present
    - name: {{ salt['pillar.get']('postgresql:replication:username', 'replication_agent') }}
    - runas: postgres
    - superuser: True
    - require:
      - service: postgresql
