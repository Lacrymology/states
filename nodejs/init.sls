{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

{% set version = '0.10.32' %}
{%- set sub_version = version + "-1chl1~" +  grains['lsb_distrib_codename']  + "1" %}
{% set filename = "nodejs_" +  version  + "-1chl1~" +  grains['lsb_distrib_codename']  + "1_" +  grains['debian_arch']  + ".deb" %}

rlwrap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

nodejs:
  pkg:
    - installed
    - sources:
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
      - nodejs: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
{%- else %}
      {#- source: ppa:chris-lea/node.js #}
      - nodejs: http://archive.robotinfra.com/mirror/{{ filename }}
{%- endif %}
    - require:
      - pkg: rlwrap

{%- if salt['pkg.version']('nodejs') not in ('', sub_version) %}
nodejs_old_version:
  pkg:
    - removed
    - name: nodejs
    - require_in:
      - pkg: nodejs
{%- endif %}
