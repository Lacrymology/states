{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - clamav

extend:
  clamav-freshclam:
    service:
      - dead
      - require:
        - pkg: clamav-freshclam
    file:
      - absent
      - name: /etc/clamav/freshclam.conf
      - require:
        - service: clamav-freshclam
  clamav-daemon:
    service:
      - dead
      - require:
        - pkg: clamav-daemon
