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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
{%- set ssl = salt['pillar.get']('elasticsearch:ssl', False) %}
include:
  - apt
  - bash
  - cron
  - java.7
  - salt.minion.deps
{% if ssl %}
  - nginx
  - ssl
{% endif %}
{%- set version = salt['pillar.get']('elasticsearch:version', '0.90.10') %}

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
    - mode: 500
    - source: salt://elasticsearch/cron_daily.jinja2
    - require:
      - pkg: cron
      - file: bash

{%- call manage_pid('/var/run/elasticsearch.pid', 'elasticsearch', 'elasticsearch', 'elasticsearch') %}
- pkg: elasticsearch
{%- endcall %}

elasticsearch:
{% if salt['pillar.get']('elasticsearch:aws', False) %}
  elasticsearch_plugins:
    - installed
    - name: cloud-aws
    - url: elasticsearch/elasticsearch-cloud-aws/{{ salt['pillar.get']('elasticsearch:elasticsearch-cloud-aws_version') }}
    - require:
      - pkg: elasticsearch
{% endif %}
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
  process:
    - wait
    - name: '-Delasticsearch'
    - timeout: 10
    - require:
      - pkg: elasticsearch
      - pkg: salt_minion_deps
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - process: elasticsearch
    - watch:
      - file: /etc/default/elasticsearch
      - file: /etc/elasticsearch/logging.yml
      - file: elasticsearch
      - pkg: elasticsearch
      - pkg: jre-7
      - file: jre-7
{%- if grains['cpuarch'] == 'i686' %}
      - file: jre-7-i386
{%- endif -%}
{%- if salt['pillar.get']('elasticsearch:aws', False) %}
      - elasticsearch_plugins: elasticsearch
{%- endif %}
      - user: elasticsearch
  pkg:
    - installed
    - sources:
{%- if salt['pillar.get']('files_archive', False) %}
        - elasticsearch: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/elasticsearch-{{ version }}.deb
{%- else %}
        - elasticsearch: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ version }}.deb
{%- endif %}
    - require:
      - pkg: jre-7
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: elasticsearch

{%- if salt['pkg.version']('elasticsearch') not in ('', version) %}
elasticsearch_old_version:
  pkg:
    - removed
    - name: elasticsearch
    - require_in:
      - pkg: elasticsearch
{%- endif %}

{% if ssl %}
/etc/nginx/conf.d/elasticsearch.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 400
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
    - source: salt://nginx/proxy.jinja2
    - context:
        destination: http://127.0.0.1:9200
        http_port: False
        ssl: {{ salt['pillar.get']('elasticsearch:ssl') }}
        hostnames: {{ salt['pillar.get']('elasticsearch:hostnames') }}
        allowed:
{% for ip_address in grains['ipv4'] %}
          - {{ ip_address }}/32
{% endfor %}
{% for allowed in salt['pillar.get']('elasticsearch:https_allowed', []) %}
          - {{ allowed }}
{% endfor %}

extend:
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ salt['pillar.get']('elasticsearch:ssl') }}
{% endif %}

{#- remove old graylog2 indices #}
old_graylog2_index:
  pkg:
    - installed
    - name: curl
  cmd:
    - run
    - name: curl -XDELETE 'http://127.0.0.1:9200/graylog2-{{ grains['id'] }}_*'
    {#-
      check if graylog2 indices exist
      graylog2 prefix: graylog2-{{ grains['id'] }}_
    #}
    - onlyif: /bin/sleep 30 && curl --silent --fail -XGET 'http://127.0.0.1:9200/graylog2-{{ grains['id'] }}_*/_search?'
    - require:
      - pkg: old_graylog2_index
      - process: elasticsearch
