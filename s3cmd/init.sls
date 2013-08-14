include:
  - apt

s3cmd:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

/root/.s3cfg:
	file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://s3cmd/s3cfg.jinja
    - require:
      - pkg: s3cmd
