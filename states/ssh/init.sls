include:
  - ssh.keys
  - nrpe

/etc/nagios/nrpe.d/ssh.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://ssh/nrpe.jinja2

/root/.ssh/id_dsa:
  file:
    - managed
    - source: {{ pillar['deployment_key_source'] }}
    - user: root
    - group: root
    - mode: 400

bitbucket.org:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40

github.com:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48

openssh-server:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/ssh/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://ssh/server.jinja2
    - require:
      - pkg: openssh-server
  service:
    - running
    - enable: True
    - name: ssh
    - watch:
      - pkg: openssh-server
      - file: openssh-server

openssh-client:
  pkg:
    - latest
    - require:
      - ssh_known_hosts: bitbucket.org
      - ssh_known_hosts: github.com
      - file: /root/.ssh/id_dsa
  file:
    - managed
    - name: /etc/ssh/ssh_config
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://ssh/client.jinja2
    - require:
      - pkg: openssh-client

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ssh.cfg
