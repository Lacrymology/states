include:
  - local

{%- set version = "2013-06-28" -%}
{%- set bits = {'amd64': 64, 'i386': 32} -%}
{%- set hashes = {'amd64': '482b360988fbef2b0fb68739e32c70e6' , 'i386': 'a9ed67250d19900be86ee8059d944b14' } -%}
{%- set filename = 'ffmpeg.static.{0}bit.{1}.tar.gz'.format(bits[salt['grains.get']('debian_arch')], version) %}

ffmpeg:
  archive:
    - extracted
    - name: /usr/local/bin
    - archive_format: tar
    - tar_options: z
    - source_hash: md5={{ hashes[salt['grains.get']('debian_arch')] }}
  {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/{{ filename }}
  {%- else %}
    - source: http://ffmpeg.gusari.org/static/{{ bits[salt['grains.get']('debian_arch')] }}bit/{{ filename }}
  {%- endif %}
    - if_missing: /usr/local/bin/ffmpeg
    - require:
      - file: /usr/local
