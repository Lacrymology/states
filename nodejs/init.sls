{#
 Install NodeJS platform for Javascript.
 #}
include:
  - apt

{% set version = '0.10.12' %}
{% set filename = "nodejs_" +  version  + "-1chl1~" +  grains['lsb_codename']  + "1_" + salt['grains.get']('debian_arch') + ".deb" %}

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
      - nodejs: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ filename }}
{%- else %}
      - nodejs: http://ppa.launchpad.net/chris-lea/node.js/ubuntu/pool/main/n/nodejs/{{ filename }}
{%- endif %}
    - require:
      - pkg: rlwrap

/etc/apt/sources.list.d/chris-lea-node.js-precise.lis:
  file:
    - absent
