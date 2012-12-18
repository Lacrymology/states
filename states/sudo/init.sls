sudo:
  file:
    - managed
    - name: /etc/sudoers
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://sudo/config.jinja2
    - require:
      pkg: sudo
  pkg:
    - installed
