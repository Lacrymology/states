{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

screen:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/screenrc
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://screen/config.jinja2
    - require:
      - pkg: screen
