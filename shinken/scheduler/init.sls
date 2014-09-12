{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

State for Shinken Scheduler.

The scheduler daemon manages the dispatching of checks and actions to the
poller and reactionner daemons respectively. The scheduler daemon is also
responsible for processing the check result queue, analyzing the results, doing
correlation and following up actions accordingly (if a service is down, ask for
a host check). It does not launch checks or notifications. It just keeps a
queue of pending checks and notifications for other daemons of the architecture
(like pollers or reactionners). This permits distributing load equally across
many pollers. There can be many schedulers for load-balancing or hot standby
roles.
-#}
include:
  - shinken

shinken-scheduler:
  file:
    - managed
    - name: /etc/init/shinken-scheduler.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: scheduler
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - file: /var/lib/shinken
      - file: /var/log/shinken
    - watch:
      - user: shinken
      - cmd: shinken_modules
      - file: /etc/shinken/scheduler.conf
      - file: shinken-scheduler
{#- does not use PID, no need to manage #}

/etc/shinken/scheduler.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: scheduler
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken
