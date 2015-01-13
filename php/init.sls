{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

php:
  pkgrepo:
    - managed
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/lucid-php5 {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://php/key.gpg
{%- else %}
    - ppa: l-mierzwa/lucid-php5
{%- endif %}
    - file: /etc/apt/sources.list.d/lucid-php5.list
    - require:
      - pkg: apt_sources
