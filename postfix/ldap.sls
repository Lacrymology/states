{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
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
