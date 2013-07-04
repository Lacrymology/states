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
    - require:
      - cmd: apt_sources
