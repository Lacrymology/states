{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
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
