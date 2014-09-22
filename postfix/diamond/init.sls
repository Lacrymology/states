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

Diamond statistics for postfix.
-#}
include:
  - diamond
  - postfix
  - rsyslog
  - local

postfix_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/PostfixCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postfix/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors

postfix_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[postfix]]
        exe = ^\/usr\/lib\/postfix\/master$

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/diamond/postfix-requirements.txt:
  file:
    - absent

/var/log/mail.log:
  file:
    - managed
    - user: syslog
    - group: adm
    - mode: 640
    - require:
      - pkg: rsyslog
    - require_in:
      - service: rsyslog

/etc/rsyslog.d/postfix_stats.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - source: salt://postfix/diamond/rsyslog.jinja2
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

/etc/init/postfix_stats.conf:
  file:
    - managed
    - source: salt://postfix/diamond/upstart.jinja2
    - template: jinja
    - require:
      - module: postfix_stats
      - file: /var/log/mail.log
      - file: /etc/rsyslog.d/postfix_stats.conf

postfix_stats:
  service:
    - running
    - watch:
      - file: /etc/init/postfix_stats.conf
  file:
    - managed
    - name: /usr/local/diamond/salt-postfix-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postfix/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-postfix-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - file: postfix_stats

extend:
  diamond:
    service:
      - watch:
        - file: postfix_diamond_collector
        - module: postfix_stats
      - require:
        - service: rsyslog
        - service: postfix
      {#- make sure postfix_stat service runs before diamond postfix collector
          which gets data from it #}
      - require_in:
        - service: postfix_stats
