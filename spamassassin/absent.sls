{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
spamassassin:
  pkg:
    - purged
    - pkgs:
      - pyzor
      - spamassassin
      - razor
  file:
    - absent
    - name: /root/.pyzor
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
