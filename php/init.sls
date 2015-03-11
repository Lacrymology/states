{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}

include:
  - apt

{%- set files_archive = salt['pillar.get']('files_archive', False) %}

php:
{%- if os.is_precise %}
  pkgrepo:
    - managed
  {%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/lucid-php5 {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://php/key.gpg
  {%- else %}
    - ppa: l-mierzwa/lucid-php5
  {%- endif %}
    - file: /etc/apt/sources.list.d/lucid-php5.list
    - clean_file: True
    - require:
      - pkg: apt_sources
    - require_in:
      - pkg: php
{%- endif %}
  pkg:
    - installed
    - name: php5-cli
