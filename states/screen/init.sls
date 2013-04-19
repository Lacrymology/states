{#
 Enable mouse scrolling in screen.
 #}
include:
  - apt

screen:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/screenrc
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://screen/config.jinja2
    - require:
      - cmd: apt_sources
