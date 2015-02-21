{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - ssl.dev

ldap-dev:
  pkg:
    - installed
    - pkgs:
      - libldap2-dev
      - libsasl2-dev
    - require:
      - cmd: apt_sources
      - pkg: ssl-dev
