{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if not files_archive %}
  {%- set files_archive = "http://archive.robotinfra.com" %}
{%- endif %}

include:
  - apt

{%- set version = '1.0.1' %}
graylog:
  pkgrepo:
    - managed
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/graylog/{{ version }} {{ grains['lsb_distrib_codename'] }} 1.0
    - key_url: salt://graylog2/pubkey.gpg
    - file: /etc/apt/sources.list.d/graylog.list
    - clean_file: True
    - require:
        - cmd: apt_sources
