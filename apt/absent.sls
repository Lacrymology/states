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
-#}

apt.conf:
  file:
    - absent
    - name: /etc/apt/apt.conf.d/99local

apt_sources:
  file:
    - rename
    - name: /etc/apt/sources.list
    - source: /etc/apt/sources.list.bak
    - force: True
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - pkgs:
      - debconf-utils
      - python-apt
      - python-software-properties
#}

apt_clean:
  cmd:
    - run
    - name: apt-get clean

apt-key:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/apt.gpg

{#- cache file from salt.states.pkg  #}
{{ opts['cachedir'] }}/pkg_refresh:
  file:
    - absent

{%- for log_file in salt['file.find']('/etc/apt/sources.list.d/', name='*.save', type='f') %}
{{ log_file }}:
  file:
    - absent
{%- endfor -%}
