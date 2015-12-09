{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - local
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
      - cmd: ca-certificates
      - cmd: system_locale
  gem:
    - installed
    - name: bundler
    - version: 1.7.3
    - user: root
    - require:
      - pkg: ruby
      - file: /usr/local
