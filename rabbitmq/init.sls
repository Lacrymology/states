{#-
RabbitMQ
========

Install a server or cluster of RabbitMQ message queue servers.

To properly use this state, the user monitor need to be changed
in WebUI to grant read access across all vhost.
as this is not yet implemented in salt.

and a admin user should be created and the user guest with default
password dropped.
as long as the default guest user and guest password combination is
is the pillar, the WebUI won't be available.

Mandatory Pillar
----------------

rabbitmq:
  cluster:
    master: node-1
    cookie: xxx
    nodes:
      node-1:
        private: 192.168.1.1
        public: 20.168.1.1
      node-2:
        private: 192.168.1.2
        public: 20.168.1.2
  vhosts:
    vhostname: vhostpassword
  monitor:
    user: monitor
    password: xxx
  management:
    user: admin
    password: xxx
  hostnames:
    - rmq.example.com

rabbitmq:cluster:master: master node ID
rabbitmq:cluster:cookie: random string used as the Erlang cookie
rabbitmq:cluster:nodes:{{ node id }}:private: IP/Hostname in LAN of RabbitMQ
    node.
rabbitmq:cluster:nodes:{{ node id }}:public: IP/Hostname reachable from Internet
    of RabbitMQ node.
rabbitmq:vhosts: dict of {'vhostname': 'password'} of all RabbitMQ virtualhosts.
rabbitmq:monitor:user: username used to perform monitoring check.
rabbitmq:monitor:password: password used to perform monitoring check.
rabbitmq:management:user: username used to perform management trough Web UI.
rabbitmq:management:password: password used to perform management trough Web UI.
rabbitmq:hostnames: list of hostnames that RabbitMQ management console is
    reachable.
message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

rabbitmq:
  ssl: example.com
shinken_pollers:
  - 192.168.1.1
destructive_absent: False

graphite_address: IP/Hostname of carbon/graphite server.
graylog2_address: IP/Hostname of centralized Graylog2 server
shinken_pollers: IP address of monitoring poller that check this server.
destructive_absent: If True (not default), RabbitMQ data saved on disk is purged
    when rabbitmq.absent is executed.
-#}
{#- TODO: configure logging to GELF -#}
{#- TODO: SSL support http://www.rabbitmq.com/ssl.html -#}

include:
  - hostname
  - apt
{% if pillar['rabbitmq']['management'] != 'guest' -%}
  {%- if pillar['rabbitmq']['ssl']|default(False) %}
  - ssl
  {%- endif %}
  - nginx
{% endif %}

{% set master_id = pillar['rabbitmq']['cluster']['master'] %}

rabbitmq:
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/rabbitmq
    - password: "*"
    - enforce_password: True
    - gid_from_name: True

/var/lib/rabbitmq:
  file:
    - directory
    - user: rabbitmq
    - group: rabbitmq
    - mode: 700
    - require:
      - user: rabbitmq

{#
 Clustering requires the same cookie to be the same on all nodes.
 It need to be created BEFORE rabbitmq-server package is installed.
 If the cookie is changed while the daemon is running, it cannot be stopped
 using regular startup script and need to be manually killed.
 #}

{% set version = '3.1.2' %}
rabbitmq_erlang_cookie:
  file:
    - managed
    - name: /var/lib/rabbitmq/.erlang.cookie
    - template: jinja
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
    - source: salt://rabbitmq/cookie.jinja2
    - require:
      - file: /var/lib/rabbitmq

rabbitmq_dependencies:
  pkg:
    - installed
    - pkgs:
      - erlang-nox
      - logrotate
    - require:
      - cmd: apt_sources

rabbitmq-server:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - rabbitmq-server: {{ pillar['files_archive'] }}/mirror/rabbitmq-server_{{ version }}-1_all.deb
{%- else %}
      - rabbitmq-server: http://www.rabbitmq.com/releases/rabbitmq-server/v{{ version }}/rabbitmq-server_{{ version }}-1_all.deb
{%- endif %}
    - require:
      - pkg: rabbitmq_dependencies
      - host: hostname
      - file: rabbitmq_erlang_cookie
  file:
    - directory
    - name: /etc/rabbitmq/rabbitmq.conf.d
    - require:
      - pkg: rabbitmq-server
  service:
    - running
    - enable: True
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: beam{% if grains['num_cpus'] > 1 %}.smp{% endif %}
    - require:
      - pkg: rabbitmq-server
    - watch:
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
{#  rabbitmq_vhost:#}
{#    - present#}
{#    - name: test#}
{#    - require:#}
{#      - service: rabbitmq-server#}
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['monitor']['user'] }}
    - password: {{ pillar['rabbitmq']['monitor']['password'] }}
    - force: True
    - require:
      - service: rabbitmq-server

{% for vhost in salt['pillar.get']('rabbitmq:vhosts', []) %}
rabbitmq-vhost-{{ vhost }}:
  rabbitmq_user:
    - present
    - name: {{ vhost }}
    - password: {{ pillar['rabbitmq']['vhosts'][vhost] }}
    - force: True
    - require:
      - service: rabbitmq-server
  rabbitmq_vhost:
    - present
    - name: {{ vhost }}
    - user: {{ vhost }}
    - require:
      - rabbitmq_user: rabbitmq-vhost-{{ vhost }}
{% endfor %}

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
{% endif %}

{% for node in pillar['rabbitmq']['cluster']['nodes'] -%}
    {% if node != grains['id'] -%}
host_{{ node }}:
  host:
    - present
    - name: {{ node }}
    - ip: {{ pillar['rabbitmq']['cluster']['nodes'][node]['private'] }}
    {% endif %}
{% endfor %}

{% if pillar['rabbitmq']['management'] != 'guest' %}
/etc/nginx/conf.d/rabbitmq.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 400
    - source: salt://nginx/proxy.jinja2
    - require:
      - pkg: nginx
    - context:
      destination: http://127.0.0.1:15672
      ssl: {{ pillar['rabbitmq']['ssl']|default(False) }}
      hostnames: {{ pillar['rabbitmq']['hostnames'] }}
{% endif %}

{% if pillar['rabbitmq']['management'] != 'guest' %}
extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/rabbitmq.conf
  {% if pillar['rabbitmq']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['rabbitmq']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['rabbitmq']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['rabbitmq']['ssl'] }}/ca.crt
  {% endif %}
{% endif %}


/etc/apt/sources.list.d/www.rabbitmq.com-debian-testing.list:
  file:
    - absent
