{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- from "iojs/map.jinja2" import iojs with context %}

iojs_deps:
  pkg:
    - installed
    - pkgs:
      - rlwrap
    - require:
      - cmd: apt_sources

{%- if salt['pkg.version']('iojs') not in ('', iojs.version) %}
iojs_old_version:
  pkg:
    - removed
    - name: iojs
    - require_in:
      - pkg: iojs
{%- endif %}

iojs:
  pkg:
    - installed
    - sources:
      - iojs: {{ iojs.source }}
    - require:
      - pkg: iojs_deps
