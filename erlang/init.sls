{#- Installing Erlang interpreters #}
include:
  - apt

erlang:
  pkg:
    - latest
    - name: erlang-nox
    - require:
      - cmd: apt_sources