{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
