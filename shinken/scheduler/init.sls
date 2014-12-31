{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>

State for Shinken Scheduler.

The scheduler daemon manages the dispatching of checks and actions to the
poller and reactionner daemons respectively. The scheduler daemon is also
responsible for processing the check result queue, analyzing the results, doing
correlation and following up actions accordingly (if a service is down, ask for
a host check). It does not launch checks or notifications. It just keeps a
queue of pending checks and notifications for other daemons of the architecture
(like pollers or reactionners). This permits distributing load equally across
many pollers. There can be many schedulers for load-balancing or hot standby
roles.
-#}
{%- from 'shinken/init.sls' import shinken_install_module with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - rsyslog
  - shinken
{%- if ssl %}
  - ssl
{%- endif %}

{%- if salt['pillar.get']('files_archive', False) %}
    {%- call shinken_install_module('pickle-retention-file-scheduler') %}
- source_hash: md5=216da06b322f72fab4f7c7c0673f96cd
    {%- endcall %}
{%- else %}
    {{ shinken_install_module('pickle-retention-file-scheduler') }}
{%- endif %}

shinken-scheduler:
  file:
    - managed
    - name: /etc/init/shinken-scheduler.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
        shinken_component: scheduler
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - file: /var/lib/shinken
      - file: /var/run/shinken
    - watch:
      - user: shinken
      - cmd: shinken
      - cmd: shinken-module-pickle-retention-file-scheduler
      - file: /etc/shinken/scheduler.conf
      - file: shinken-scheduler
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}

{% from 'upstart/rsyslog.jinja2' import manage_upstart_log with context %}
{{ manage_upstart_log('shinken-scheduler') }}

/etc/shinken/scheduler.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
        shinken_component: scheduler
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken
