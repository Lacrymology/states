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
Maintainer: Bruno Clermont <patate@fastmail.cn>
       Hung Nguyen Viet <hvnsweeting@gmail.com>
-#}
include:
  - bash
  - cron
  - jenkins
  - jenkins.git
  - local
  - salt.cloud
  - salt.master
  - ssh.client
  - sudo
  - virtualenv

extend:
  salt-cloud-boostrap-script:
    file:
      - source: salt://salt/ci/bootstrap.jinja2

{#- this file no longer managed on salt ci VM, use one provided by build #}
/usr/local/bin/retcode_check.py:
  file:
    - absent

{%- for script in ('import_test_data', 'wait_minion_up') %}
/usr/local/bin/{{ script }}.py:
  file:
    - managed
    - source: salt://salt/ci/{{ script }}.py
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local
      - module: pysc
{%- endfor %}

/etc/salt/master.d/ci.conf:
  file:
    - managed
    - source: salt://salt/ci/master.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: salt-master
    - watch_in:
      - service: salt-master

/etc/sudoers.d/jenkins:
  file:
    - managed
    - source: salt://salt/ci/sudo.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/var/lib/jenkins/salt-test.sh:
  file:
    - absent

/var/lib/jenkins/salt-build.sh:
  file:
    - absent

/var/lib/jenkins/salt-post.sh:
  file:
    - managed
    - user: jenkins
    - group: nogroup
    - mode: 500
    - source: salt://salt/ci/post.jinja2
    - template: jinja
    - require:
      - pkg: jenkins
      - file: bash

/etc/cron.d/salt-archive-ci:
  file:
    - absent

/srv/salt/jenkins_archives:
  file:
    - directory
    - user: jenkins
    - group: root
    - mode: 750
    - require:
      - pkg: jenkins
      - file: /srv/salt

ci-agent:
  user:
    - present
  file:
    - name: /home/ci-agent/.ssh
    - directory
    - user: ci-agent
    - group: ci-agent
    - mode: 750
    - require:
      - user: ci-agent

/home/ci-agent/.ssh/authorized_keys:
  file:
    - managed
    - user: ci-agent
    - group: ci-agent
    - mode: 400
    - contents: |
        {{ pillar['salt']['ci']['authorized_keys']|indent(8) }}
    - require:
      - file: ci-agent

/etc/cron.daily/ci-agent-cleanup-build-logs:
  file:
    - managed
    - mode: 500
    - contents: |
        find /home/ci-agent \( -name '*.xz' -or -name '*.xml' -mtime +1 \) -delete
    - require:
      - pkg: cron
      - user: ci-agent
