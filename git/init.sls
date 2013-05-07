{#
 Configure a git client with most commonly used open-source SSH based git server
 #}
include:
  - ssh.client
  - apt

git:
  pkg:
    - latest
    - require:
      - pkg: openssh-client
      - cmd: apt_sources
      - ssh_known_hosts: github.com
      - ssh_known_hosts: bitbucket.org
