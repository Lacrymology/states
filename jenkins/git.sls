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

Jenkins is optional depends on git, only when you use Jenkins to build
code from git. This formula setup some things that needed to make jenkins works
with git, not to install jenkins git plugin or setup private ssh key - which
must be done by user used jenkins web UI
#}
include:
  - git
  - jenkins
  - ssh.client

{%- set jenkins_home = '/var/lib/jenkins' %}

{{ jenkins_home }}/.ssh:
  file:
    - directory
    - user: jenkins
    - group: nogroup # default groups of jenkins
    - mode: 700
    - require:
      - pkg: jenkins

jenkins_set_git_email:
  cmd:
    - wait
    - name: git config --global user.email "{{ pillar['smtp']['user'] }}"
    - user: jenkins
    - watch:
      - pkg: git
    - require:
      - pkg: jenkins
    - require_in:
      - service: jenkins

jenkins_set_git_user:
  cmd:
    - run
    - name: git config --global user.name "Continous Integration"
    - user: jenkins
    - watch:
      - pkg: git
    - require:
      - pkg: jenkins
    - require_in:
      - service: jenkins
