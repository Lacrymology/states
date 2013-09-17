{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
ruby:
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
      - ruby1.9.3
      - ruby1.9.1-dev

/.gem:
  file:
    - absent

/var/lib/gems:
  file:
    - absent
