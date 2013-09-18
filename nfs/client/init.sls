{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - apt

nfs-common:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
