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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

How to create a snapshot of saltstack Ubuntu PPA::

  wget -m -I /saltstack/salt/ubuntu/ \
    http://ppa.launchpad.net/saltstack/salt/ubuntu/
  mv ppa.launchpad.net/saltstack/salt/ubuntu/dists \
    ppa.launchpad.net/saltstack/salt/ubuntu/pool .
  rm -rf ppa.launchpad.net
  find . -type f -name 'index.*' -delete
  find pool/ -type f ! -name '*.deb' -delete

To only keep precise & trusty::

   rm -rf `find dists/ -maxdepth 1 -mindepth 1 ! -name precise ! -name trusty`
   # because some deb can be used for all (E.g: salt-api)
   find pool/ \( -type f -name '*.deb' \( -name '*lucid*' -or  -name '*oneiric*' -or  -name '*quantal*' -or  -name '*raring*' -or -name '*saucy*' \) \) -delete
-#}
include:
  - apt
  - salt.patch_salt

{%- for i in ('list', 'list.save') %}
salt_absent_old_apt_salt_{{ i }}:
  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_codename'] }}.{{ i }}
{%- endfor %}

{%- from "macros.jinja2" import salt_version with context %}
{%- set version = salt_version() %}
salt:
  pkg:
    - installed
    - name: salt-common
    - require_in:
      - file: patch_salt_fix_require_sls
{%- if grains['saltversion'].startswith('0.17') %}
  pkgrepo17:
{%- else %}
  pkgrepo:
{%- endif %}
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/salt/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://archive.robotinfra.com/mirror/salt/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- endif %}
    - file: /etc/apt/sources.list.d/saltstack-salt.list
    - key_url: salt://salt/key.gpg
    - require:
      - cmd: apt_sources
      - file: salt_absent_old_apt_salt_list
      - file: salt_absent_old_apt_salt_list.save
    - require_in:
      - pkg: salt
  cmd: {#- the state which act as an API, consumer only need to watch this if it need to watch changes of this SLS #}
    - wait
    - name: echo "state(s) in ``salt`` have been changed"
    - watch:
      - pkg: salt
      - file: patch_salt_fix_require_sls
