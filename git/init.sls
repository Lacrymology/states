{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Configure a git client with most commonly used open-source SSH based git server
 -#}
include:
  - ssh.client
  - apt

git:
  pkg:
    - latest
{%- if grains['osrelease']|float < 12.04 %}
    - name: git-core
{%- endif %}
    - require:
      - pkg: openssh-client
      - cmd: apt_sources
      - file: known_hosts
