{#
 Diamond statistics for RabbitMQ
#}
{% set master_id = pillar['rabbitmq']['cluster']['master'] %}
include:
  - diamond
  - pip
  - apt
{% if grains['id'] != master_id %}
  - rabbitmq
{% endif -%}
{%- if pillar['rabbitmq']['management'] != 'guest' %}
  - nginx.diamond
{% endif %}

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
        exe = ^\/usr\/lib\/erlang\/erts-.+\/bin\/inet_gethost$,^\/usr\/lib\/erlang\/erts-.+\/bin\/beam.+rabbitmq.+$,^\/usr\/lib\/erlang\/erts-.+\/bin\/epmd$
        cmdline = ^inet_gethost 4$

diamond-pyrabbit:
  file:
    - managed
    - name: /usr/local/diamond/salt-pyrabbit-requirements.txt
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
    - requirements: /usr/local/diamond/salt-pyrabbit-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - file: diamond-pyrabbit

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
  pkg:
    - latest
    - name: python-httplib2
    - require:
      - cmd: apt_sources

extend:
  diamond:
    service:
      - watch:
        - file: diamond_rabbitmq
{% if grains['id'] != master_id %}
  in_rabbitmq_cluster:
    rabbitmq_cluster:
      - require:
        - module: diamond-pyrabbit
{% endif %}
