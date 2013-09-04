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

extend:
  github.com:
    ssh_known_hosts:
      - user: jenkins
      - require:
        - pkg: jenkins
      - watch_in:
        - service: jenkins
