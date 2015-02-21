{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

whois:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
