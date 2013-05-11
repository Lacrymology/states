{#
 State to configure bash
 #}
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

root_profile:
  file:
    - append
    - name: {{ salt['user.info']('root')['home'] }}/.bashrc
    - text: source /etc/profile.d/bash_prompt.sh
