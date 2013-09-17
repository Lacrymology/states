{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

Bash
====

State to configure bash.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.
-#}
include:
  - apt

bash:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/profile.d/bash_prompt.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 555
    - source: salt://bash/config.jinja2
    - require:
      - pkg: bash

{{ salt['user.info']('root')['home'] }}/.bashrc:
  file:
    - absent
