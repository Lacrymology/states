{#-
Copyright (c) 2013, <BRUNO CLERMONT>
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

Author: Bruno Clermont patate@fastmail.cn
Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - local

{%- set version = "2013-06-28" -%}
{%- set bits = {'amd64': 64, 'i386': 32} -%}
{%- set hashes = {'amd64': '482b360988fbef2b0fb68739e32c70e6' , 'i386': 'a9ed67250d19900be86ee8059d944b14' } -%}
{%- set filename = 'ffmpeg.static.{0}bit.{1}.tar.gz'.format(bits[grains['debian_arch']], version) %}

ffmpeg:
  archive:
    - extracted
    - name: /usr/local/bin
    - archive_format: tar
    - tar_options: z
    - source_hash: md5={{ hashes[grains['debian_arch']] }}
  {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/{{ filename }}
  {%- else %}
    - source: http://ffmpeg.gusari.org/static/{{ bits[grains['debian_arch']] }}bit/{{ filename }}
  {%- endif %}
    - if_missing: /usr/local/bin/ffmpeg
    - require:
      - file: /usr/local
