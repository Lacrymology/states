{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

erlang:
  pkg:
    - latest
    - name: erlang-nox
    - require:
      - cmd: apt_sources
