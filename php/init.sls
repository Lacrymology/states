include:
  - apt

php:
  pkg:
    - latest
    - name: php5
    - require:
      - cmd: apt_sources
