{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - amavis
  - apt
  - clamav

extend:
  clamav-daemon:
    service:
      - watch:
        - user: clamav-daemon
      - require:
        - pkg: amavis
    user:
      - present
      - name: clamav
      - groups:
        - amavis
      - require:
        - pkg: clamav-daemon
        - pkg: amavis
  amavis:
    user:
      - groups:
        - clamav
      - require:
        - pkg: clamav-daemon
      - watch_in:
        - service: amavis
