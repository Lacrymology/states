{#
Install Redis
#}

{% set jemalloc = "libjemalloc1_3.4.0-1chl1~{0}1_{1}.deb".format(grains['lsb_codename'], grains['debian_arch']) %}
{% set filename = "redis-server_2.6.14-1chl1~{0}1_{1}.deb".format(grains['lsb_codename'], grains['debian_arch']) %}

redis:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - libjemalloc1: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ jemalloc }}
      - redis-server: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ filename }}
{%- else %}
      - libjemalloc1: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/j/jemalloc/{{ jemalloc }}
      - redis-server: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/r/redis/{{ filename }}
{%- endif %}
  file:
    - managed
    - template: jinja
    - source: salt://redis/config.jinja2
    - name: /etc/redis/redis.conf
    - makedirs: True
    - require:
      - pkg: redis
  service:
    - name: redis-server
    - running
    - watch:
      - file: redis
      - pkg: redis
