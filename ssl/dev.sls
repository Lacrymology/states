include:
  - apt

ssl-dev:
  pkg:
    - installed
    - name: libssl-dev
    - require:
      - cmd: apt_sources
