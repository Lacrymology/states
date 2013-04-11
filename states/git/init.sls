{#
 Configure a git client with most commonly used open-source SSH based git server
 #}
include:
  - ssh.client

git:
  pkg:
    - latest
    - require:
      - pkg: openssh-client
