include:
  - ssh

git:
  pkg:
    - latest
    - refresh: True
    - require:
      - pkg: openssh-client
