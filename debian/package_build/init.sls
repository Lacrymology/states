{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - apt
  - build

package_build:
  pkg:
    - latest
    - pkgs:
      - debhelper
      - dpkg-dev
      - build-essential
      - fakeroot
    - require:
      - cmd: apt_sources
