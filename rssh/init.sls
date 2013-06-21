include:
  - apt

rssh:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/rssh.conf
    - source: salt://rssh/config.jinja2
    - template: jinja
    - mode: 444
    - user: root
    - group: root
    - require:
      - pkg: rssh
