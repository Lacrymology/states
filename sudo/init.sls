include:
  - apt
  - rsyslog

sudo:
  file:
    - managed
    - name: /etc/sudoers
    - source: salt://sudo/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: sudo
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - service: rsyslog
