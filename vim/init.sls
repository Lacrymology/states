{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install VIM a vi compatible editor.
 -#}
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
