{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{% set master_id = salt['pillar.get']('rabbitmq:cluster:master') %}
include:
  - apt
  - diamond
  - pip
  - rabbitmq
  - nginx.diamond

rabbitmq_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[rabbitmq]]
        exe = ^\/usr\/lib\/erlang\/erts-.+\/bin\/inet_gethost$,^\/usr\/lib\/erlang\/erts-.+\/bin\/epmd$
        cmdline = ^inet_gethost 4$,^\/usr\/lib\/erlang\/erts-.+\/bin\/beam.+rabbitmq.+$,

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/diamond/salt-pyrabbit-requirements.txt:
  file:
    - absent

diamond-pyrabbit:
  file:
    - managed
    - name: /usr/local/diamond/salt-rabbitmq-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://rabbitmq/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-rabbitmq-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - file: diamond-pyrabbit
{%- if grains['id'] != master_id %}
    - require_in:
      - rabbitmq_cluster: join_rabbitmq_cluster
{%- endif %}

diamond_rabbitmq:
  file:
    - managed
    - template: jinja
    - name: /etc/diamond/collectors/RabbitMQCollector.conf
    - user: root
    - group: root
    - mode: 440
    - source: salt://rabbitmq/diamond/config.jinja2
    - require:
      - module: diamond-pyrabbit
      - file: /etc/diamond/collectors
{%- if grains['id'] == master_id %}
      - rabbitmq_user: monitor_user
{%- endif %}
    - watch_in:
      - service: diamond
  pkg:
    - latest
    - name: python-httplib2
    - require:
      - cmd: apt_sources

{% if grains['id'] != master_id %}
extend:
  diamond:
    service:
      - require:
        - service: rabbitmq-server
  join_rabbitmq_cluster:
    rabbitmq_cluster:
      - require:
        - module: diamond-pyrabbit
{% endif %}
