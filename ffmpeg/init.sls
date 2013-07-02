ffmpeg:
  archive:
    - extracted
    - name: /usr/local/bin
    - archive_format: tar
    - tar_options: z
{%- set version = "2013-04-24" -%}
{%- if grains['debian_arch'] == 'amd64' %}
    - source: http://ffmpeg.gusari.org/static/64bit/ffmpeg.static.64bit.{{ version }}.tar.gz
    - source_hash: md5=ae465ac9514106f36f712ac1b8ec95be
{%- else %}
    - source: http://ffmpeg.gusari.org/static/32bit/ffmpeg.static.32bit.{{ version }}.tar.gz
    - source_hash: md5=873786aa9fabe7c24cce014e99120815
{%- endif %}
    - if_missing: /usr/local/bin/ffmpeg
