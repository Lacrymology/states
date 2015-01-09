{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
include:
  - apt

{% set version = '0.10.32' %}
{%- set sub_version = version + "-1chl1~" +  grains['lsb_distrib_codename']  + "1" %}
{% set filename = "nodejs_" +  version  + "-1chl1~" +  grains['lsb_distrib_codename']  + "1_" +  grains['debian_arch']  + ".deb" %}

rlwrap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

nodejs:
  pkg:
    - installed
    - sources:
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
      - nodejs: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
{%- else %}
      - nodejs: http://ppa.launchpad.net/chris-lea/node.js/ubuntu/pool/main/n/nodejs/{{ filename }}
{%- endif %}
    - require:
      - pkg: rlwrap

{%- if salt['pkg.version']('nodejs') not in ('', sub_version) %}
nodejs_old_version:
  pkg:
    - removed
    - name: nodejs
    - require_in:
      - pkg: nodejs
{%- endif %}

/etc/apt/sources.list.d/chris-lea-node.js-precise.lis:
  file:
    - absent
