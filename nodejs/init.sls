{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}

include:
  - apt

{%- set files_archive = salt['pillar.get']('files_archive', False) %}

nodejs:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
{%- if os.is_trusty %}
    - pkgs:
      - nodejs-legacy
      - npm
{%- elif os.is_precise %}
  {%- set version = '0.10.32' %}
  {%- set sub_version = version + "-1chl1~" +  grains['lsb_distrib_codename']  + "1" %}
  {%- set filename = "nodejs_" +  version  + "-1chl1~" +  grains['lsb_distrib_codename']  + "1_" +  grains['debian_arch']  + ".deb" %}
    - sources:
  {%- if files_archive %}
      - nodejs: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
  {%- else %}
      {#- source: ppa:chris-lea/node.js #}
      - nodejs: http://archive.robotinfra.com/mirror/{{ filename }}
  {%- endif %}

rlwrap:
  pkg:
    - installed
    - require_in:
      - pkg: nodejs
{%- endif %}
