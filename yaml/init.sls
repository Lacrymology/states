{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

yaml:
  pkg:
    - installed
    - name: libyaml-dev
    - require:
      - cmd: apt_sources
