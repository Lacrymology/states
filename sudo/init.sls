include:
  - apt
  - gsyslog

sudo:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - service: gsyslog
