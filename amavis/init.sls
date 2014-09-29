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

Amavis: A Email Virus Scanner.
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - bash
  - cron
  - mail
  - spamassassin
  - amavis.clamav

amavis:
  pkg:
    - latest
    - name: amavisd-new
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
  service:
    - running
    - order: 50
    - watch:
      - pkg: amavis
    - require:
      - pkg: spamassassin

/etc/amavis/conf.d/50-user:
  file:
    - managed
    - source: salt://amavis/config.jinja2
    - template: jinja
    - mode: 440
    - watch_in:
      - service: amavis

/etc/cron.daily/amavisd-new:
  file:
    - managed
    - source: salt://amavis/cron_daily.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 500
    - require:
      - pkg: cron

{%- call manage_pid('/var/run/amavis/amavisd.pid', 'amavis', 'amavis', 'amavis', 640) %}
- pkg: amavis
{%- endcall %}
