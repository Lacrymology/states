{#- Usage of this is governed by a license that can be found in doc/license.rst

Jenkins is optional depends on git, only when you use Jenkins to build
code from git. This formula setup some things that needed to make jenkins works
with git, not to install jenkins git plugin or setup private ssh key - which
must be done by user used jenkins web UI
-#}

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
    - name: git config --global user.email "{{ salt['pillar.get']('smtp:user', None) }}"
    - user: jenkins
    - watch:
      - pkg: git
    - require:
      - pkg: jenkins
    - require_in:
      - service: jenkins

jenkins_set_git_user:
  cmd:
    - wait
    - name: git config --global user.name "Continous Integration"
    - user: jenkins
    - watch:
      - pkg: git
    - require:
      - pkg: jenkins
    - require_in:
      - service: jenkins
