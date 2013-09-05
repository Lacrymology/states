include:
  - git
  - jenkins
  - ssh.client

jenkins_set_git_email:
  cmd:
    - run
    - name: git config --global user.email "{{ salt['pillar.get']('jenkins:git:email', 'jenkins@localhost') }}"
    - user: jenkins
    - require:
      - pkg: git
      - pkg: jenkins
    - require_in:
      - service: jenkins

jenkins_set_git_user:
  cmd:
    - run
    - name: git config --global user.name "{{ salt['pillar.get']('jenkins:git:name', 'Jenkins') }}"
    - user: jenkins
    - require:
      - pkg: git
      - pkg: jenkins
    - require_in:
      - service: jenkins

/var/lib/jenkins/plugins/git-client.hpi:
  file:
    - managed
    - source: http://updates.jenkins-ci.org/download/plugins/git-client/1.1.2/git-client.hpi
    #TODO mirror
    - source_hash: md5=303be65cc9dd7bb2b33629dacdd8b0eb
    - user: jenkins
    - group: nogroup
    - require:
      - pkg: git
      - pkg: jenkins
    - watch_in:
      - service: jenkins

/var/lib/jenkins/plugins/git.hpi:
  file:
    - managed
    - source: http://updates.jenkins-ci.org/download/plugins/git/1.5.0/git.hpi
    #TODO mirror
    - source_hash: md5=6cbad4214729056ea62d93b69fb5c05e
    - user: jenkins
    - group: nogroup
    - watch_in:
      - service: jenkins
    - require:
      - pkg: git
      - pkg: jenkins

{%- from 'ssh/client/init.sls' import knownhost with context %}
{{ knownhost('bitbucket.org', '97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40', 'jenkins') }}
    - require:
      - pkg: openssh-client
      - pkg: jenkins
    - watch_in:
      - service: jenkins

{{ knownhost('github.com', '16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48', 'jenkins') }}
    - require:
      - pkg: openssh-client
      - pkg: jenkins
    - watch_in:
      - service: jenkins

{% set user_home = '/var/lib/jenkins' %}
{%- if 'ssh_private_key' in pillar['jenkins'] %}
jenkins_ssh_private_key:
  file:
    - managed
    - name: {{ user_home }}/.ssh/id_{{ salt['pillar.get']('jenkins:ssh_private_key:type') }}
    - contents: |
        {{ salt['pillar.get']('jenkins:ssh_private_key:contents') | indent(8) }}
    - user: jenkins
    - group: nogroup
    - mode: 400
    - require:
      - pkg: jenkins
      - ssh_known_hosts: jenkins_github.com
{%- endif %}

{%- if 'ssh_config' in pillar['jenkins'] %}
{{ user_home }}/.ssh/config:
  file:
    - managed
    - user: jenkins
    - group: nogroup
    - contents: |
        {{ salt['pillar.get']('jenkins:ssh_config') | indent(8) }}
    - require:
      - ssh_known_hosts: jenkins_github.com
      - pkg: jenkins
{%- endif %}

{%- for domain in salt['pillar.get']('jenkins:git_servers', []) %}
{{ knownhost(domain, pillar['jenkins']['git_servers'][domain]['fingerprint'], 'jenkins', pillar['jenkins']['git_servers'][domain]['port']) }}
    - require:
      - pkg: openssh-client
      - pkg: jenkins
    - watch_in:
      - service: jenkins
{%- endfor %}
