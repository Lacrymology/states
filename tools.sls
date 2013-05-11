{#
list of useful packages we really want to have everywhere
tools for troubleshooting
#}

include:
  - apt

basic:
  pkg:
    - latest
    - names:
      - htop
      - iftop
      - iotop
      - nmap
      - screen
      - tshark
    - skip_verify: True
    - require:
      - cmd: apt_sources
