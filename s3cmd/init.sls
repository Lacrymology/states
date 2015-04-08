{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

s3cmd:
  pkg:
    - latest
    - pkgs:
      - s3cmd
      - python-magic
    - require:
      - cmd: apt_sources

/root/.s3cfg:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://s3cmd/config.jinja2
    - require:
      - pkg: s3cmd
