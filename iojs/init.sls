{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

{%- set files_archive = salt['pillar.get']('files_archive', False) %}

iojs_deps:
  pkg:
    - installed
    - pkgs:
      - rlwrap
    - require:
      - cmd: apt_sources

iojs:
  pkg:
    - installed
    - sources:
{%- if files_archive %}
        - iojs: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/iojs/iojs_1.3.0-1nodesource1~trusty1_{{ grains['osarch'] }}.deb
{%- else %}
        - iojs: https://deb.nodesource.com/iojs_1.x/pool/main/i/iojs/iojs_1.3.0-1nodesource1~trusty1_{{ grains['osarch'] }}.deb
{%- endif %}
    - require:
      - pkg: iojs_deps
