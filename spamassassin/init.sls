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
