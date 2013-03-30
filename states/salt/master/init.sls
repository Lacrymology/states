include:
  - salt.minion
  - git
  - ssh.client
  - nrpe
  - diamond

salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - source: salt://salt/master/config.jinja2
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
    - enable: True
    - watch:
      - pkg: salt-master

salt_master_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt.master]]
        name = ^salt\-master

/etc/nagios/nrpe.d/salt-master.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/master/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-master.cfg

