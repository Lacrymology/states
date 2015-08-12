{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - amavis
  - apt
  - clamav

extend:
  clamav:
    user:
      - groups:
        - amavis
      - require:
        - pkg: clamav-daemon
        - pkg: amavis
      - watch_in:
        - service: clamav-daemon
        - service: clamav-freshclam
  amavis:
    user:
      - groups:
        - clamav
      - require:
        - pkg: clamav-daemon
      - watch_in:
        - service: amavis
