{#-
Copyright (c) 2013, Lam Dang Tung
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

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>
-#}
{%- set web_root_dir = "/usr/local/openerp" %}

openerp:
  group:
    - absent
    - require:
      - user: openerp
  user:
    - absent
    - name: openerp
    - force: True
  file:
    - absent
    - name: {{ web_root_dir }}

openerp-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/openerp.yml
    - require:
      - file: /etc/nginx/conf.d/openerp.conf
  cmd:
    - run
    - name: pkill -9 -f [o]penerp-master || true
    - require:
      - file: openerp-uwsgi

/usr/local/openerp/config.yaml:
  file:
    - absent

/etc/nginx/conf.d/openerp.conf:
  file:
    - absent

/etc/rsyslog.d/openerp-upstart.conf:
  file:
    - absent

openerp-cron:
  service:
    - dead
  file:
    - absent
    - name: /etc/init/openerp.conf
    - require:
      - service: openerp-cron

{{ opts['cachedir'] }}/pip/openerp:
  file:
    - absent
