{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install Ruby interpreter.
 -#}
include:
  - apt
  - locale

old_ruby:
  pkg:
    - purged
    - pkgs:
      - ruby1.8
      - rubygems
      - rake
      - ruby-dev
      - libreadline5
      - libruby1.8
      - ruby1.8-dev

ruby:
  pkg:
    - installed
    - pkgs:
      - ruby1.9.3
      - ruby1.9.1-dev
    - require:
      - pkg: old_ruby
      - cmd: apt_sources
