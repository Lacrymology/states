{#-
Copyright (c) 2014, Diep Pham
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

Author: Diep Pham <favadi@robotinfra.com>
Maintainer: Diep Pham <favadi@robotinfra.com>

uwsgi build for ruby2
#}
include:
  - ruby.2
  - uwsgi

{%- set version = '1.9.17.1' -%}
{%- set extracted_dir = '/usr/local/uwsgi-{0}'.format(version) %}

uwsgi_patch_fiber:
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/fiber/uwsgiplugin.py
    - source: salt://uwsgi/fiber_uwsgiplugin.patch
    - hash: md5=fccd209c50eff070b62e03c18880f688
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

uwsgi_patch_rack:
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/rack/uwsgiplugin.py
    - source: salt://uwsgi/rack_uwsgiplugin.patch
    - hash: md5=6eb5b904fc74e673b73c02a27c511170
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

uwsgi_patch_rbthreads:
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/rbthreads/uwsgiplugin.py
    - source: salt://uwsgi/rbthreads_uwsgiplugin.patch
    - hash: md5=f7a8556a012dd7cf78e8adaa854a55d2
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: ruby2
    cmd:
      - watch:
        - pkg: ruby2
        - file: uwsgi_patch_fiber
        - file: uwsgi_patch_rack
        - file: uwsgi_patch_rbthreads
