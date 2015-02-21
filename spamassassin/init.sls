{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
