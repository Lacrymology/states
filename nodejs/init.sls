{#
 Install NodeJS platform for Javascript.
 #}
include:
  - apt

{% set version = '0.10.12' %}
rlwrap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

nodejs:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - nodejs: {{ pillar['files_archive'] }}/mirror/nodejs_{{ version }}-1chl1~precise1_{{ grains['debian_arch'] }}.deb
{%- else %}
      - nodejs: http://ppa.launchpad.net/chris-lea/node.js/ubuntu/pool/main/n/nodejs/nodejs_{{ version }}-1chl1~precise1_{{ grains['debian_arch'] }}.deb
{%- endif %}
    - require:
      - pkg: rlwrap
