{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - ruby
  - uwsgi

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: ruby
    cmd:
      - watch:
        - pkg: ruby
