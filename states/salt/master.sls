include:
  - salt
  - git
  - ssh

salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - source: salt://salt/master.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
  cmd:
    - run
    - cwd: /srv/salt
    - name: git config remote.origin.url {{ pillar['salt']['repository'] }}; git config branch.master.merge refs/heads/master
    - require:
      - pkg: git
  git:
    - latest
    - name: {{ pillar['salt']['repository'] }}
    - target: /srv/salt/
    - require:
      - pkg: openssh-client
      - pkg: git
      - cmd: salt-master
  pkg:
    - latest
    - require:
      - apt_repository: salt-minion
  service:
    - running
    - watch:
      - pkg: salt-master
