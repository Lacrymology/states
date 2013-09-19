include:
  - test.sync

{% set version = "0.5.1-1chl1~lucid1" %}
python-unittest2:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
    - python-unittest2: {{ pillar['files_archive']|replace('file://', '') }}/mirror/python-unittest2_{{ version }}_all.deb
{%- else %}
    - python-unittest2: http://ppa.launchpad.net/chris-lea/python-unittest2/ubuntu/pool/main/u/python-unittest2_{{ version }}_all.deb
{%- endif %}
    - require:
      - file: salt_archive
