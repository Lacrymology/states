{# TODO: configure logging to GELF #}

include:
  - diamond
  - nrpe
  - pip
  - hostname

{% set master_id = pillar['rabbitmq']['cluster']['master'] %}

rabbitmq_erlang_cookie:
  file:
    - managed
    - name: /var/lib/rabbitmq/.erlang.cookie
    - template: jinja
    - user: rabbitmq
    - group: rabbitmq
    - mode: 440
    - source: salt://rabbitmq/cookie.jinja2

rabbitmq-server:
  apt_repository:
    - present
    - address: http://www.rabbitmq.com/debian/
    - components:
      - main
    - distribution: testing
    - key_server: pgp.mit.edu
    - key_id: 056E8E56
  pkg:
    - latest
    - require:
      - apt_repository: rabbitmq-server
      - file: rabbitmq_erlang_cookie
  file:
    - directory
    - name: /etc/rabbitmq/rabbitmq.conf.d
    - require:
      - pkg: rabbitmq-server
  service:
    - running
    - enabled: true
    - require:
      - pkg: rabbitmq-server
    - watch:
      - apt_repository: rabbitmq-server
      - file: rabbitmq-server
      - rabbitmq_plugins: rabbitmq-server
{% for node in pillar['rabbitmq']['cluster']['nodes'] %}
    {% if node != grains['id'] %}
      - host: host_{{ node }}
    {% endif %}
{% endfor %}
  rabbitmq_plugins:
    - enabled
    - name: rabbitmq_management
    - env: HOME=/var/lib/rabbitmq
    - require:
      - pkg: rabbitmq-server
{% if grains['id'] == master_id %}
  rabbitmq_vhost:
    - present
    - name: test
    - require:
      - service: rabbitmq-server
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['monitor']['user'] }}
    - password: {{ pillar['rabbitmq']['monitor']['password'] }}
    - force: True
    - require:
      - service: rabbitmq-server
{% endif %}

{% if grains['id'] != master_id %}
in_rabbitmq_cluster:
  rabbitmq_cluster:
    - joined
    - master: {{ master_id }}
    - env: HOME=/var/lib/rabbitmq
    - user: {{ pillar['rabbitmq']['management']['user'] }}
    - password: {{ pillar['rabbitmq']['management']['password'] }}
    - disk_node: True
    - require:
      - rabbitmq_plugins: rabbitmq-server
      - service: rabbitmq-server
      - pip: diamond_rabbitmq
{% endif %}

diamond_rabbitmq:
  pip:
    - installed
    - upgrade: True
    - name: pyrabbit
    - require:
      - pkg: python-pip
  file:
    - managed
    - template: jinja
    - name: /etc/diamond/collectors/RabbitMQCollector.conf
    - user: root
    - group: root
    - mode: 440
    - source: salt://rabbitmq/diamond.jinja2
    - require:
      - pip: diamond_rabbitmq
  pkg:
    - latest
    - name: python-httplib2

{% for node in pillar['rabbitmq']['cluster']['nodes'] -%}
    {% if node != grains['id'] -%}
host_{{ node }}:
  host:
    - present
    - name: {{ node }}
    - ip: {{ pillar['ip_addresses'][node] }}
    {% endif %}
{% endfor %}

/etc/nagios/nrpe.d/rabbitmq.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://rabbitmq/nrpe.jinja2

extend:
  diamond:
    service:
      - watch:
        - file: diamond_rabbitmq
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/rabbitmq.cfg
