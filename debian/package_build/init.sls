include:
  - apt

package_build:
  pkg:
    - latest
    - pkgs:
      - debhelper
      - dpkg-dev
    - require:
      - cmd: apt_sources
