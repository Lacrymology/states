{#-
 Install Fluxbox - Windows Manager
#}

include:
  - apt

fluxbox:
  pkg:
    - latest
    - pkgs:
      - eterm
      - fluxbox
    - require:
      - cmd: apt_sources
