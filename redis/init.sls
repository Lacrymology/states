{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context %}
{%- from "os.jinja2" import os with context %}

{%- if os.is_precise %}
  {%- set redis_version = "2.8.4" %}
  {%- set jemalloc_version = "3.4.1" %}
  {%- set redis_sub_version = "2:{0}-1chl1~{1}1".format(redis_version, grains['lsb_distrib_codename']) %}
  {%- set jemalloc_sub_version = "{0}-1chl1~{1}1".format(jemalloc_version, grains['lsb_distrib_codename']) %}
  {%- set jemalloc = "libjemalloc1_{0}-1chl1~{1}1_{2}.deb".format(jemalloc_version, grains['lsb_distrib_codename'], grains['debian_arch']) %}
  {%- set filename = "redis-server_{0}-1chl1~{1}1_{2}.deb".format(redis_version, grains['lsb_distrib_codename'], grains['debian_arch']) %}
  {%- set redistools = "redis-tools_{0}-1chl1~{1}1_{2}.deb".format(redis_version, grains['lsb_distrib_codename'], grains['debian_arch']) %}
{%- endif %}

redis:
  file:
    - managed
    - template: jinja
    - source: salt://redis/config.jinja2
    - name: /etc/redis/redis.conf
    - user: redis
    - group: redis
    - mode: 440
    - require:
      - pkg: redis
  service:
    - running
    - enable: True
    - name: redis-server
    - order: 50
    - watch:
      - file: redis
      - file: /etc/init.d/redis-server
      - pkg: redis
      - user: redis
  pkg:
    - installed
{%- if os.is_precise %}
    - sources:
  {%- set files_archive = salt['pillar.get']('files_archive', False) %}
  {%- if files_archive %}
      - libjemalloc1: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ jemalloc }}
      - redis-server: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
      - redis-tools: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ redistools }}
  {%- else %}
      {#- source: http://ppa.launchpad.net/chris-lea/redis-server #}
      - libjemalloc1: http://archive.robotinfra.com/mirror/{{ jemalloc }}
      - redis-server: http://archive.robotinfra.com/mirror/{{ filename }}
      - redis-tools: http://archive.robotinfra.com/mirror/{{ redistools }}
  {%- endif %}
{%- elif os.is_trusty %}
    - name: redis-server
{%- endif %}
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: redis

/etc/init.d/redis-server:
  file:
    - managed
    - source: salt://redis/sysvinit.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - require:
      - pkg: redis

{%- call manage_pid('/var/run/redis/redis-server.pid', 'redis', 'redis', 'redis-server') %}
- pkg: redis
{%- endcall %}
