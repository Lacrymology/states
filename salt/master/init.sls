{#
 Install a Salt Management Master (server)
 #}
include:
  - salt.minion
  - git
  - ssh.client
  - pip

GitPython:
  pip:
    - installed
    - require:
      - module: pip

/srv/salt:
  file:
    - absent

{{ opts['cachedir'] }}/role-based-states:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

{{ opts['cachedir'] }}/role-based-states/top.sls:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/master/top.jinja2
    - require:
      - file: {{ opts['cachedir'] }}/role-based-states

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
      - apt_repository: salt-minion
  service:
    - running
    - enable: True
    - watch:
      - pkg: salt-master
      - file: salt-master
      - pip: GitPython
