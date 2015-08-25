{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

apparmor:
  pkg:
    - installed
    - pkgs:
      - apparmor
      - apparmor-utils
    - require:
      - cmd: apt_sources
  service:
    - running
    - watch:
      - pkg: apparmor
