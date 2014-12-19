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

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
include:
  - rsyslog
  - xinetd

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('rsync') }}

extend:
  rsync:
    pkg:
      - installed
    service:
      - require_in:
        - service: xinetd

/etc/xinetd.d/rsync:
  file:
    - managed
    - source: salt://rsync/xinetd.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - context:
        per_source: {{ salt['pillar.get']('rsync:limit_per_ip', '"UNLIMITED"') }}
    - require:
      - file: /etc/xinetd.d
    - watch_in:
      - service: xinetd

/etc/rsyncd.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://rsync/config.jinja2
    - require:
      - pkg: rsync
    - watch_in:
      - service: xinetd
