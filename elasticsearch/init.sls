{# TODO: Diamond + http://www.elasticsearch.org/guide/reference/modules/jmx/ #}
{#
 Install an Elasticsearch NoSQL server or cluster

 Elasticsearch don't support HTTP over SSL/HTTPS.
 The only way to secure access to admin interface over HTTPS is to proxy
 a SSL frontend in front of Elasticsearch HTTP interface.
 This is why nginx is used if SSL is in pillar.
 #}
{% set ssl = pillar['elasticsearch']['ssl']|default(False) %}
include:
  - apt
  - cron
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
      - pkg_file: elasticsearch

/etc/elasticsearch/logging.yml:
  file:
    - managed
    - template: jinja
    - user: elasticsearch
    - group: elasticsearch
    - mode: 440
    - source: salt://elasticsearch/logging.jinja2
    - require:
      - pkg_file: elasticsearch

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
      - pkg: elasticsearch
{% endif %}

elasticsearch:
  pkg:
    - latest
    - name: openjdk-7-jre-headless
    - require:
      - cmd: apt_sources
{% if 'aws' in pillar['elasticsearch'] %}
  elasticsearch_plugins:
    - installed
    - name: cloud-aws
    - url: elasticsearch/elasticsearch-cloud-aws/{{ pillar['elasticsearch']['elasticsearch-cloud-aws_version'] }}
    - require:
      - pkg_file: elasticsearch
{% endif %}
  pkg_file:
    - installed
    - name: elasticsearch
    - version: {{ version }}
    - source: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ version }}.deb
    - source_hash: {{ checksum }}
    - require:
      - pkg: elasticsearch
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
      - pkg_file: elasticsearch
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/default/elasticsearch
      - file: /etc/elasticsearch/logging.yml
      - file: elasticsearch
      - pkg_file: elasticsearch
      - pkg: elasticsearch
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
{% for allowed in pillar['elasticsearch']['https_allowed'] %}
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
