{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - apt

spamassassin:
  pkg:
    - latest
    - pkgs:
      - spamassassin
      - pyzor
      - razor
    - require:
      - cmd: apt_sources

pyzor discover:
  cmd:
    - wait
    - watch:
      - pkg: spamassassin
