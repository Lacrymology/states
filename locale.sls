{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
Set the locale for machine
-#}
include:
  - apt
{% set encoding = salt['pillar.get']('encoding', 'en_US.UTF-8') %}

system_locale:
  locale:
    - system
    - name: {{ encoding }}
    - require:
      - pkg: language_pack
  cmd:
    - wait
    - name: locale-gen {{ encoding }}
    - watch:
      - locale: system_locale

language_pack:
  pkg:
    - installed
    - name: language-pack-{{ encoding.split('_')[0] }}
    - require:
      - cmd: apt_sources
