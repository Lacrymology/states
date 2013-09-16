{#
list of useful packages we really want to have everywhere
tools for troubleshooting
#}

include:
  - apt
  - screen

basic:
  pkg:
    - latest
    - pkgs:
      - htop
      - iftop
      - iotop
      - nmap
      - tshark
    - skip_verify: True
    - require:
      - cmd: apt_sources
