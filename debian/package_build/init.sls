{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
