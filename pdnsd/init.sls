{#-
Copyright (c) 2013, Hung Nguyen Viet
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

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Install a DNS cache server.
-#}
include:
  - apt

pdnsd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - debconf: pdnsd
  debconf:
    - set
    - data:
        'pdnsd/conf': {'type': 'select', 'value': 'Manual'}
    - require:
      - pkg: apt_sources
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: /etc/default/pdnsd
      - file: /etc/pdnsd.conf
      - pkg: pdnsd
{#- PID file owned by root, no need to manage #}

/etc/default/pdnsd:
  file:
    - managed
    - require:
      - pkg: pdnsd
    - template: jinja
    - source: salt://pdnsd/init.jinja2
    - user: root
    - group: root
    - mode: 440

/etc/pdnsd.conf:
  file:
    - managed
    - require:
      - pkg: pdnsd
    - template: jinja
    - source: salt://pdnsd/config.jinja2
    - user: root
    - group: root
    - mode: 440
