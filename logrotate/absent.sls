{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - quagga.absent

logrotate:
  pkg:
    - purged
    - require:
      - debconf: quagga
