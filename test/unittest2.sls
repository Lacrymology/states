{% set version = "0.5.1-1chl1~lucid1" %}
python-unittest2:
  pkg_file:
    - installed
    - name: python-unittest2
    - version: {{ version }}
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/python-unittest2_{{ version }}_all.deb
{%- else %}
    - source: http://ppa.launchpad.net/chris-lea/python-unittest2/ubuntu/pool/main/u/python-unittest2_{{ version }}_all.deb
{%- endif %}
    - source_hash: md5=2119a66515cf2161d9a6b1ca978167bc
