{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

whois:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
