{#-
Copyright (c) 2013, Quan Tong Anh
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

Author: Quan Tong Anh <tonganhquan.net@gmail.com>
Maintainer: Quan Tong Anh <tonganhquan.net@gmail.com>

A Python tool that can analyze the SSL configuration of a server
-#}
{% set version = "0.9" %}
include:
  - virtualenv

/usr/local/sslyze/src:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - require:
      - virtualenv: sslyze

sslyze:
  virtualenv:
    - manage
    - name: /usr/local/sslyze
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
  archive:
    - extracted
    - name: /usr/local/sslyze/src
    - source: https://github.com/iSECPartners/sslyze/releases/download/release-{{ version }}/sslyze-{{ version|replace(".", "_") }}-linux64.zip
    - source_hash: md5=1b5a235f97db11cc2f72ccb499d861f0
    - archive_format: zip
    - if_missing: /usr/local/sslyze/src/sslyze-{{ version|replace(".", "_") }}-linux64
    - require:
      - file: /usr/local/sslyze/src
  cmd:
    - wait
    - cwd: /usr/local/sslyze/src/sslyze-{{ version|replace(".", "_") }}-linux64
    - name: /usr/local/sslyze/bin/python setup.py install
    - watch:
      - archive: sslyze
