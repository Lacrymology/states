include:
  - ssh.keys
  - nrpe

/etc/nagios/nrpe.d/ssh.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://ssh/nrpe.jinja2

openssh-server:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/ssh/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://ssh/server.jinja2
    - require:
      - pkg: openssh-server
  service.running:
    - name: ssh
    - watch:
      - pkg: openssh-server
      - file: openssh-server

openssh-client:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/ssh/ssh_config
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://ssh/client.jinja2
    - require:
      - pkg: openssh-client

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ssh.cfg
