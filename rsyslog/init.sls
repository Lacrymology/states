include:
  - apt

rsyslog:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/rsyslog.conf
    - template: jinja
    - source: salt://rsyslog/config.jinja2
  service:
    - running
    - watch:
      - pkg: rsyslog
      - file: rsyslog
