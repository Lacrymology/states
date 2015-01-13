{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Configure a git client with most commonly used open-source SSH based git server.
-#}
include:
  - apt
  - ssh.client

git:
  pkgrepo:
    - managed
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/git {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://git/key.gpg
{%- else %}
    - ppa: git-core/ppa
{%- endif %}
    - file: /etc/apt/sources.list.d/git-core.list
    - require:
      - pkg: apt_sources
  pkg:
    - latest
{%- if grains['osrelease']|float < 12.04 %}
    - name: git-core
{%- endif %}
    - require:
      - pkg: openssh-client
      - cmd: apt_sources
      - file: known_hosts
      - pkgrepo: git
