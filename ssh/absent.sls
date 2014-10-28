include:
  - ssh.server.absent
  - ssh.client.absent

/etc/ssh:
  file:
    - absent
    - require:
      - file: openssh-server
      - file: openssh-client
