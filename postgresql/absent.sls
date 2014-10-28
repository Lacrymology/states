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
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Undo postgresql state.
-#}
/etc/apt/sources.list.d/postgresql.list:
  file:
    - absent

apt-key del 8683D8A2:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 8683D8A2

postgresql-dev:
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - name: libpq-dev
#}
  pkgrepo:
    - absent
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/postgresql/ {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - ppa: pitti/postgresql
{%- endif %}
  file:
    - absent
    - name: /etc/apt/sources.list.d/pitti-postgresql-{{ grains['oscodename'] }}.list
    - require:
      - pkgrepo: postgresql-dev
