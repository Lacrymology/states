{#
 State to configure bash
 #}
include:
  - apt

bash:
  pkg:
    - latest
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
      - cmd: apt_sources

root_profile:
  file:
    - append
    - name: /root/.bashrc
    - text: source /etc/profile.d/bash_prompt.sh
