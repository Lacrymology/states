bash:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/profile.d/bash_prompt.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - source: salt://bash/ps1.jinja2
    - require:
      - pkg: bash

root_profile:
  file:
    - append
    - name: /root/.bashrc
    - text: source /etc/profile.d/bash_prompt.sh
