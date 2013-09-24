include:
  - apt

ldap-dev:
  pkg:
    - installed
    - names:
      - libldap2-dev
      - libsasl2-dev
      - libssl-dev
    - require:
      - cmd: apt_sources
