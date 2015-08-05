{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

spamassassin:
  pkg:
    - purged
    - pkgs:
      - pyzor
      - spamassassin
      - razor
  file:
    - absent
    - name: /var/lib/amavis/.pyzor
    - require:
      - pkg: spamassassin
  user:
    - absent
    - name: debian-spamd
    - require:
      - pkg: spamassassin
  group:
    - absent
    - name: debian-spamd
    - require:
      - user: spamassassin
