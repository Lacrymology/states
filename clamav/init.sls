include:
  - apt

clamav-daemon:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  service:
    - running
    - names:
      - clamav-daemon
      - clamav-freshclam
    - watch:
      - file: clamav-daemon
      - pkg: clamav-daemon
  file:
    - managed
    - name: /etc/clamav/freshclam.conf
    - source: salt://clamav/freshclam.jinja2
    - template: jinja
    - mode: 400
    - user: clamav
    - group: clamav
    - require:
      - pkg: clamav-daemon
