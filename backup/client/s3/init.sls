{#-
Copyright (c) 2013, Nicolas Plessis
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

Author: Nicolas Plessis <nicolasp@microsigns.com>
Maintainer: Nicolas Plessis <nicolasp@microsigns.com>
-#}
include:
  - bash
  - local
  - backup.client.base
  - python.dev
  - s3cmd
  - virtualenv

/usr/local/bin/backup-store:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://backup/client/s3/backup-store.jinja2
    - require:
      - pkg: s3cmd
      - file: /usr/local
      - file: bash

s3lite:
  virtualenv:
    - manage
    - name: /usr/local/s3lite
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
  file:
    - managed
    - name: /usr/local/s3lite/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/client/s3/s3lite/requirements.jinja2
    - require:
      - virtualenv: s3lite
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/s3lite/bin/pip
    - requirements: /usr/local/s3lite/salt-requirements.txt
    - watch:
      - file: s3lite
      - pkg: python-dev

/etc/s3lite.yml:
  file:
    - managed
    - template: jinja
    - mode: 400
    - user: root
    - group: root
    - source: salt://backup/client/s3/s3lite/config.jinja2

{#- anyuser/program should can run this script, it just needs to provide
the config file as default config file is only for root #}
/usr/local/s3lite/bin/s3lite:
  file:
    - managed
    - source: salt://backup/client/s3/s3lite/s3lite.py
    - user: root
    - group: root
    - mode: 551
    - require:
      - module: s3lite
      - file: /etc/s3lite.yml
