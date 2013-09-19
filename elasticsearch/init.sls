{#-
Elasticsearch Daemon
====================

Install an Elasticsearch NoSQL server or cluster.

Elasticsearch don't support HTTP over SSL/HTTPS.
The only way to secure access to admin interface over HTTPS is to proxy
a SSL frontend in front of Elasticsearch HTTP interface.
This is why nginx is used if SSL is in pillar.

Mandatory Pillar
----------------

elasticsearch:
  cluster:
    name: xxx
    nodes:
      server-alpha:
        _network:
          public: 204.168.1.1
          private: 192.168.1.1
        graylog2.server:
          name: graylog2
          port: 9400
          http: false
      server-beta:
        _network:
          public: 204.168.1.1
          private: 192.168.1.1
        elasticsearch: {}
  hostnames:
    - search.example.com
message_do_not_modify: Warning message to not modify file.

elasticsearch:cluster:name: Name of this ES cluster for all listed nodes.
elasticsearch:nodes: dict of nodes part of the cluster.
elasticsearch:nodes:{{ node minion ID }}:_network:public: this node hostname
    or public IP to reach it from Internet.
elasticsearch:nodes:{{ node minion ID }}:_network:private: this node hostname
    or public IP to reach it from internal network.
elasticsearch:nodes:{{ node minion ID }}:{{ state }}: a node can only actual
    run a ES standalone node, or a graylog2.server state.
elasticsearch:nodes:{{ node minion ID }}:{{ state }}:name: node ID, must be
    unique across all node instances.
elasticsearch:nodes:{{ node minion ID }}:{{ state }}:port: ES transport port.
    if multiple instances of ES run on the same host, the port must be
    different. Default: 9300.
elasticsearch:nodes:{{ node minion ID }}:{{ state }}:http: if this instance
    handle ES HTTP API port. only one HTTP API instance is required for each
    host. Default: True.

Optional Pillar
---------------

elasticsearch:
  heap_size: 512M
  ssl: example.com
  https_allowed:
    - 192.168.0.0/24
destructive_absent: False
shinken_pollers:
  - 192.168.1.1
graphite_address: 192.168.1.1

elasticsearch:heap_size: Java format of max memory consumed by JVM heap.
    default is JVM default.
elasticsearch:ssl: SSL key set to use to publish ES trough HTTPS.
elasticsearch:https_allowed: only used if elasticsearch:ssl is defined.
    List of CIDR format network where ES over HTTPS is allowed.
destructive_absent: If True (not default), ES data saved on disk is purged when
    elasticsearch.absent is executed.
graphite_address: IP/Hostname of carbon/graphite server.
shinken_pollers: IP address of monitoring poller that check this server.

TODO: document AWS pillars
-#}
{#- TODO: Diamond + http://www.elasticsearch.org/guide/reference/modules/jmx/ -#}
{%- set ssl = pillar['elasticsearch']['ssl']|default(False) %}
include:
  - apt
  - cron
  - java.7
{% if ssl %}
  - ssl
  - nginx
{% endif %}
{% set version = '0.20.5'%}
{% set checksum = 'md5=e244c5a39515983ba81006a3186843f4' %}

/etc/default/elasticsearch:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/default.jinja2
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/logging.yml:
  file:
    - managed
    - template: jinja
    - user: elasticsearch
    - group: elasticsearch
    - mode: 440
    - source: salt://elasticsearch/logging.jinja2
    - require:
      - pkg: elasticsearch

/etc/cron.daily/elasticsearch-cleanup:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://elasticsearch/cron_daily.jinja2
    - require:
      - pkg: cron

{% if grains['cpuarch'] == 'i686' %}
/usr/lib/jvm/java-7-openjdk:
  file:
    - symlink
    - target: /usr/lib/jvm/java-7-openjdk-i386
    - require:
      - pkg: openjdk_jre_headless
{% endif %}

elasticsearch:
{% if 'aws' in pillar['elasticsearch'] %}
  elasticsearch_plugins:
    - installed
    - name: cloud-aws
    - url: elasticsearch/elasticsearch-cloud-aws/{{ pillar['elasticsearch']['elasticsearch-cloud-aws_version'] }}
    - require:
      - pkg: elasticsearch
{% endif %}
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
        - elasticsearch: {{ pillar['files_archive']|replace('file://', '') }}/mirror/elasticsearch-{{ version }}.deb
{%- else %}
        - elasticsearch: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ version }}.deb
{%- endif %}
    - require:
      - pkg: openjdk_jre_headless
  file:
    - managed
    - name: /etc/elasticsearch/elasticsearch.yml
    - template: jinja
    - user: elasticsearch
    - group: elasticsearch
    - mode: 440
    - source: salt://elasticsearch/config.jinja2
    - context:
      master: 'true'
      data: 'true'
      origin_state: elasticsearch
    - require:
      - pkg: elasticsearch
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: /etc/default/elasticsearch
      - file: /etc/elasticsearch/logging.yml
      - file: elasticsearch
      - pkg: elasticsearch
      - pkg: openjdk_jre_headless
{% if grains['cpuarch'] == 'i686' %}
      - file: /usr/lib/jvm/java-7-openjdk
{% endif %}
{% if 'aws' in pillar['elasticsearch'] %}
      - elasticsearch_plugins: elasticsearch
{% endif %}

{% if ssl %}
/etc/nginx/conf.d/elasticsearch.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - require:
      - pkg: nginx
    - mode: 400
    - source: salt://nginx/proxy.jinja2
    - context:
      destination: http://127.0.0.1:9200
      http_port: False
      ssl: {{ pillar['elasticsearch']['ssl'] }}
      hostnames: {{ pillar['elasticsearch']['hostnames'] }}
      allowed:
{% for ip_address in grains['ipv4'] %}
        - {{ ip_address }}/32
{% endfor %}
{% for allowed in pillar['elasticsearch']['https_allowed']|default([]) %}
        - {{ allowed }}
{% endfor %}
{% endif %}

{% if ssl %}
extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/elasticsearch.conf
        - cmd: /etc/ssl/{{ pillar['elasticsearch']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['elasticsearch']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['elasticsearch']['ssl'] }}/ca.crt
{% endif %}
