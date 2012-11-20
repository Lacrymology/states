postgresql-dev:
  apt_repository:
    - ubuntu_ppa
    - user: pitti
    - name: postgresql
    - key: 8683D8A2
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - file: postgresql-repo
