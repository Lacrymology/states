{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

apparmor:
  service:
    - dead
  pkg:
    - purged
    - pkgs:
      - apparmor
      - apparmor-utils
    - require:
      - service: apparmor
