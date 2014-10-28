{#-
Copyright (c) 2014, Dang Tung Lam
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

Author: Dang Tung Lam <lamdt@familug.org>
Maintainer: Dang Tung Lam <lamdt@familug.org>

Uninstall ejabberd - XMPP Server
#}

ejabberd:
  pkg:
    - purged
    - require:
      - service: ejabberd
  service:
    - dead
  cmd:
    - wait
    - name: epmd -kill
    - watch:
      - pkg: ejabberd
  user:
    - absent
    - require:
      - pkg: ejabberd
      - cmd: ejabberd
  group:
    - absent
    - require:
      - user: ejabberd

{%- for file in ('/var/lib/ejabberd', '/etc/ejabberd', '/var/log/ejabberd', '/usr/lib/ejabberd') %}
{{ file }}:
  file:
    - absent
    - name: {{ file }}
    - require:
      - pkg: ejabberd
{%- endfor %}

ejabberd-backups:
  cmd:
    - wait
    - name: rm -rf /var/backups/ejabberd-*
    - watch:
      - pkg: ejabberd
