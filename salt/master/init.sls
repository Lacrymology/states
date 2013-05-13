{#
 Install a Salt Management Master (server)

 If you install a salt master from scratch, check and run bootstrap_archive.py
 and use it to install the master.
 #}
include:
  - salt
  - git
  - ssh.client
  - pip
  - python.dev
  - apt

GitPython:
  pip:
    - installed
    - require:
      - module: pip
    - watch:
      - pkg: python-dev

/srv/salt:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

/srv/salt/top.sls:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/master/top.jinja2
    - require:
      - file: /srv/salt

salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - source: salt://salt/master/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: salt-master
  git:
    - latest
    - name: {{ pillar['salt_master']['pillar_remote'] }}
    - target: /srv/pillar
    - require:
      - pkg: git
  pkg:
    - latest
    - require:
      - apt_repository: salt
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - require:
      - pkg: git
    - watch:
      - pkg: salt-master
      - file: salt-master
      - pip: GitPython
