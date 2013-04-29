{#
 Install a Salt Management Master (server)
 #}
include:
  - salt.minion
  - git
  - ssh.client

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
    - source: salt://master/top.jinja2
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
  git:
    - latest
    - name: {{ pillar['salt']['pillar_remote'] }}
    - target: /srv/pillar
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
      - file: salt-master
