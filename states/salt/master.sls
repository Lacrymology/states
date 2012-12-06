include:
  - salt
  - git
  - ssh

salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - source: salt://salt/master.py
    - user: root
    - group: root
    - mode: 400
  git:
    - managed
    - name: {{ pillar['salt']['repository'] }}
    - latest: True
    - target: /srv/salt/
    - require:
      - pkg: openssh-client
      - pkg: git
  pkg:
    - latest
    - require:
      apt_repository: salt-minion
  service:
    - running
    - watch:
      - pkg: salt-master
