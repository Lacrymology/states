include:
  - apt

nfs-common:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
