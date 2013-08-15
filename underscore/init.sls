{#-
Installing Underscore
-#}
include:
  - apt
{%- set version = '1.4.2-1chl1~precise1' %}
libjs-underscore:
  pkgrepo:
    - managed
    - ppa: chris-lea/libjs-underscore
  pkg:
    - installed
    - version: {{ version }}
    - require:
      - pkgrepo: libjs-underscore
      - cmd: apt_sources
