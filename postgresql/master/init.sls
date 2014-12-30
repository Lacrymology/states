{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
