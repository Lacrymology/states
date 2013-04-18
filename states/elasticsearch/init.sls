{# TODO: Diamond + http://www.elasticsearch.org/guide/reference/modules/jmx/ #}
{#
 Install an Elasticsearch NoSQL server or cluster

 Elasticsearch don't support HTTP over SSL/HTTPS.
 The only way to secure access to admin interface over HTTPS is to proxy
 a SSL frontend in front of Elasticsearch HTTP interface.
 This is why nginx is used if SSL is in pillar.
 #}
{% set ssl = pillar['elasticsearch']['ssl']|default(False) and 'public' in pillar['elasticsearch']['cluster']['nodes'][grains['id']] %}
include:
  - diamond
  - nrpe
  - requests
  - apt
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

{% if grains['cpuarch'] == 'i686' %}
/usr/lib/jvm/java-7-openjdk:
  file:
    - symlink
    - target: /usr/lib/jvm/java-7-openjdk-i386
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
      http: 'true'
      master: 'true'
      data: 'true'
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
        - 127.0.0.1/32
{% for allowed in pillar['elasticsearch']['https_allowed'] %}
        - {{ allowed }}
{% endfor %}
{% endif %}

elasticsearch_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[elasticsearch]]
        cmdline = .+java.+\-cp \:\/usr\/share\/elasticsearch\/lib\/elasticsearch\-.+\.jar

/etc/nagios/nrpe.d/elasticsearch.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://elasticsearch/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/elasticsearch-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe_instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: elasticsearch
      http_port: 9200
      domain_name: 127.0.0.1
      https: {{ ssl }}

/usr/local/bin/check_elasticsearch_cluster.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
  file:
    - managed
    - source: salt://elasticsearch/check.py
    - mode: 555
    - require:
      - module: nagiosplugin
      - module: requests

elasticsearch_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/ElasticSearchCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/diamond.jinja2
    - require:
      - file: /etc/diamond/collectors

extend:
  diamond:
    service:
      - watch:
        - file: elasticsearch_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/elasticsearch.cfg
        - file: /etc/nagios/nrpe.d/elasticsearch-nginx.cfg
{% if ssl %}
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/elasticsearch.conf
        - cmd: /etc/ssl/{{ pillar['elasticsearch']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['elasticsearch']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['elasticsearch']['ssl'] }}/ca.crt
{% endif %}
