{#-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - locale
  - ssl

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
      {#- gem requires SSL to works when packages are available trough https #}
      - pkg: ssl-cert
      - cmd: system_locale
