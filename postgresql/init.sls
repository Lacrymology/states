include:
  - apt

postgresql-dev:
  apt_repository:
    - ubuntu_ppa
    - user: pitti
    - name: postgresql
    - key_id: 8683D8A2
  pkg:
    - latest
    - name: libpq-dev
    - require:
      - apt_repository: postgresql-dev
      - cmd: apt_sources
