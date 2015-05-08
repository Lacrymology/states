{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- from "os.jinja2" import os with context %}
{%- from "postgresql/map.jinja2" import postgresql with context %}

include:
  - apt
{% if ssl %}
  - ssl
{% endif %}

{%- set repo = postgresql["repo_configs"][postgresql.version]["repo"] %}
{%- set key = postgresql["repo_configs"][postgresql.version]["key"] %}
postgresql-dev:
{%- if repo and key %}
  pkgrepo:
    - managed
    - name: {{ repo }}
    - key_url: salt://postgresql/{{ key }}
    - require_in:
      - pkg: postgresql-dev
    - file: /etc/apt/sources.list.d/postgresql.list
    - clean_file: True
    - require:
      - pkg: apt_sources
{%- endif %}
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - cmd: apt_sources

postgresql-common:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

postgres:
  user:
    - present
    - shell: /usr/sbin/nologin
    {%- if ssl %}
    - groups:
      - ssl-cert
    {%- endif %}
    - require:
      - pkg: postgresql-common
    {%- if ssl %}
      - pkg: ssl-cert
    {%- endif %}
