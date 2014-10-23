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
include:
  - salt

python-pip:
  pkg:
    - installed

unittest-xml-reporting:
  pip:
    - installed
    - name: http://archive.robotinfra.com/mirror/unittest-xml-reporting-a4d6593eb9b85996021285cc2ca3830701fcfe9b.tar.gz
    - require:
      - pkg: python-pip

{%- from "macros.jinja2" import salt_deb_version with context %}
salt-minion:
  pkg:
    - installed
    - version: {{ salt_deb_version() }}
    - require:
{%- if grains['saltversion'].startswith('0.17') %}
      - pkgrepo17: salt
{%- else %}
      - pkgrepo: salt
{%- endif %}
      - pkg: python-pip
      - pip: unittest-xml-reporting
  file:
    - patch
    - name: /usr/share/pyshared/salt/state.py
    - hash: md5=cb303bf87a7584e1de6843049c122dd8
    - source: salt://salt/require_sls.patch
  service:
    - running
    - enable: True
    - skip_verify: True
    - watch:
      - pkg: salt-minion
      - file: salt-minion
