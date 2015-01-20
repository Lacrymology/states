{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
include:
  - apt
{% if ssl %}
  - ssl
{% endif %}

postgresql-dev:
  pkgrepo:
    - managed
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/postgresql/9.2.4-0 {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://postgresql/key.gpg
{%- else %}
    - ppa: pitti/postgresql
{%- endif %}
    - file: /etc/apt/sources.list.d/postgresql.list
    - clean_file: True
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - pkgrepo: postgresql-dev
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
