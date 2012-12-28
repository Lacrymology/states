include:
  - ssh.client

git:
  pkg:
    - latest
    - require:
      - pkg: openssh-client
