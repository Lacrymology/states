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
    - mode: 400
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
      - cmd: rabbitmq-repo
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
      - pkg: rabbitmq-server
      - file: rabbitmq-server
      - rabbitmq_plugins: rabbitmq-server
  rabbitmq_plugins:
    - enabled
    - name: rabbitmq_management
    - env: HOME=/var/lib/rabbitmq
{% if grains['id'] == master_id %}
  rabbitmq_vhost:
    - present
    - name: test
    - require:
      - pkg: rabbitmq-server
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['monitor']['user'] }}
    - password: {{ pillar['rabbitmq']['monitor']['password'] }}
    - force: True
    - require:
      - pkg: rabbitmq-server
{% endif %}

pyrabbit:
  pip:
    - installed
    - name: pyrabbit
    - require:
      - pkg: python-pip

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
      - pip: pyrabbit
{% endif %}

diamond_rabbitmq:
  file:
    - managed
    - template: jinja
    - name: /etc/diamond/collectors/RabbitMQCollector.conf
    - user: root
    - group: root
    - mode: 600
    - source: salt://rabbitmq/diamond.jinja2
    - require:
      - pip: pyrabbit
  pkg:
    - installed
    - name: python-httplib2

/etc/nagios/nrpe.d/rabbitmq.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://rabbitmq/nrpe.jinja2

{% for node in pillar['rabbitmq']['cluster']['nodes'] -%}
    {% if node != grains['id'] -%}
host_{{ node }}:
  host:
    - present
    - name: {{ node }}
    - ip: {{ salt['publish.publish'](node, 'grains.item', 'privateIp')[node] }}
    {% endif %}
{% endfor %}

extend:
  diamond:
    service:
      - watch:
        - file: diamond_rabbitmq
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/rabbitmq.cfg
  /etc/hosts:
    file:
      - source: salt://rabbitmq/hosts.jinja2
