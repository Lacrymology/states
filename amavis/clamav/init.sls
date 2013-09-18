{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - apt
  - clamav
  - amavis

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
      - present
      - groups:
        - clamav
      - require:
        - pkg: clamav-daemon
      - watch_in:
        - service: amavis
