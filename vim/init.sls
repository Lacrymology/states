{#
 Install VIM a vi compatible editor.
 #}
include:
  - apt

vim:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

vim-tiny:
  pkg:
    - purged
