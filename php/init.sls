{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "php/map.jinja2" import php with context %}

include:
  - apt

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set repo = php["repo_configs"][php.version]["repo"] %}
{%- set key = php["repo_configs"][php.version]["key"] %}

php:
{%- if repo and key %}
  pkgrepo:
    - managed
    - name: {{ repo }}
    - key_url: salt://php/{{ key }}
    - file: /etc/apt/sources.list.d/php.list
    - clean_file: True
    - require:
      - pkg: apt_sources
    - require_in:
      - pkg: php
{%- endif %}
  pkg:
    - installed
    - name: php5-cli

/etc/apt/sources.list.d/lucid-php5.list:
  file:
    - absent
