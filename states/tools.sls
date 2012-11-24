{#
list of useful packages we really want to have everywhere
tools for troubleshooting
#}
basic:
  pkg:
    - latest
    - names:
      - command-not-found
      - debconf
      - htop
      - iftop
      - iotop
      - nmap
      - screen
      - tshark
      - pciutils
      - dmidecode
    - skip_verify: True
