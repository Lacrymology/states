include:
  - ssh.client
  - git
  - mercurial

python-pip:
  pkg:
    - latest
    - require:
      - pkg: openssh-client
      - pkg: git
      - pkg: mercurial
