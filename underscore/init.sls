{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
{%- set version = '1.4.2-1chl1~precise1' %}
libjs-underscore:
  pkgrepo:
    - managed
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/underscore/1.4.2-1 {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://underscore/key.gpg
{%- else %}
    - ppa: chris-lea/libjs-underscore
{%- endif %}
    - file: /etc/apt/sources.list.d/chris-lea-libjs-underscore-{{ grains['oscodename'] }}.list
    - clean_file: True
    - require:
      - cmd: apt_sources
  pkg:
    - installed
    - version: {{ version }}
    - require:
      - pkgrepo: libjs-underscore
      - cmd: apt_sources
