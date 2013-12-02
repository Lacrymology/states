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

How to create a snapshot of saltstack Ubuntu PPA::

  wget -m -I /saltstack/salt/ubuntu/ \
    http://ppa.launchpad.net/saltstack/salt/ubuntu/
  mv ppa.launchpad.net/saltstack/salt/ubuntu/dists \
    ppa.launchpad.net/saltstack/salt/ubuntu/pool .
  rm -rf ppa.launchpad.net
  find . -type f -name 'index.*' -delete
  find pool/ -type f ! -name '*.deb' -delete

To only keep lucid/precise::

   rm -rf `find dists/ -maxdepth 1 -mindepth 1 ! -name lucid ! -name precise`
   find pool/ -type f -name '*.deb' ! -name '*lucid*'  ! -name '*precise*' -delete
-#}

salt:
  file:
    - absent
{%- if grains['saltversion'] == '0.15.3' %}
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_release'] }}.list
{%- else %}
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_release'] }}.list
{%- endif %}
  apt_repository:
    - present
{%- if 'files_archive' in pillar %}
    - address: http://archive.robotinfra.com/mirror/salt/{{ salt['pillar.get']('salt:version', '0.17.2-2') }}
{#    - address: {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/salt/{{ salt['pillar.get']('salt:version', '0.17.2-2') }}#}
{%- else %}
    - address: http://archive.robotinfra.com/mirror/salt/{{ salt['pillar.get']('salt:version', '0.17.2-2') }}
{%- endif %}
{%- if grains['saltversion'] == '0.15.3' %}
    - filename: saltstack-salt-{{ grains['lsb_codename'] }}
{%- else %}
    - filename: saltstack-salt-{{ grains['lsb_distrib_codename'] }}
{%- endif %}
    - components:
      - main
    - key_server: keyserver.ubuntu.com
    - key_id: 0E27C0A6
    - require:
      - file: salt
  pkg:
    - installed
    - name: salt-common
    - require:
      - apt_repository: salt
