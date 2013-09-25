{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Elasticsearch Daemon
====================

Install an Elasticsearch NoSQL server or cluster.

Elasticsearch don't support HTTP over SSL/HTTPS.
The only way to secure access to admin interface over HTTPS is to proxy
a SSL frontend in front of Elasticsearch HTTP interface.
This is why nginx is used if SSL is in pillar.
-#}
{#- TODO: Diamond + http://www.elasticsearch.org/guide/reference/modules/jmx/ -#}
{%- set ssl = salt['pillar.get']('elasticsearch:ssl', False) %}
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
{% for allowed in salt['pillar.get']('elasticsearch:https_allowed', []) %}
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
