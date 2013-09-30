include:
  - apt

yaml:
  pkg:
    - installed
    - name: libyaml-dev
    - require:
      - cmd: apt_sources
