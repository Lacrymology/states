include:
  - hostname
  - local
  - java.7.jdk
{% set version = '3.7.0' %}

terracotta:
  archive:
    - name: /usr/local
    - extracted
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/terracotta-{{ version }}.tar.gz
{%- else %}
    - source: http://d2zwv9pap9ylyd.cloudfront.net/terracotta-3.7.0.tar.gz
{%- endif %}
    - source_hash: md5=ff54cad0febeb8a0c17154cac838c2cb
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/terracotta-{{ version }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: /etc/init/terracotta.conf
    - source: salt://terracotta/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
      version: {{ version }}
  user:
    - present
  service:
    - running
    - order: 50
    - require:
      - pkg: openjdk_jdk
      - archive: terracotta
      - file: /var/lib/terracotta/server-statistics
      - file: /var/log/terracotta/server-logs
      - file: /var/lib/terracotta/server-data
      - user: terracotta
      - host: hostname
    - watch:
      - file: terracotta
      - file: /etc/terracotta.conf

/etc/terracotta.conf:
  file:
    - managed
    - template: jinja
    - source: salt://terracotta/config.jinja2

/var/lib/terracotta/server-data:
  file:
    - directory
    - makedirs: True
    - user: terracotta
    - group: terracotta
    - require:
      - user: terracotta

/var/log/terracotta/server-logs:
  file:
    - directory
    - makedirs: True
    - user: terracotta
    - group: terracotta
    - require:
      - user: terracotta

/var/lib/terracotta/server-statistics:
  file:
    - directory
    - makedirs: True
    - user: terracotta
    - group: terracotta
    - require:
      - user: terracotta
