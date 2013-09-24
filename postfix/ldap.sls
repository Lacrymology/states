include:
  - postfix

postfix-ldap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: postfix
    - require_in:
      - service: postfix
