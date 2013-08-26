{% set version = '3.7.0' %}

terracotta:
  archive:
    - name: /usr/local/terracotta
    - extracted
    - source: http://d2zwv9pap9ylyd.cloudfront.net/terracotta-3.7.0.tar.gz
    #- source: {{ pillar['files_archive'] }}/mirror/terracotta-{{ version }}.tar.gz
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
  service:
    - running
    - watch:
      - file: terracotta
      - archive: terracotta
