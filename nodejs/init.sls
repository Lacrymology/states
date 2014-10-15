{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Install NodeJS platform for Javascript.
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
{%- if 'files_archive' in pillar %}
      - nodejs: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
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
