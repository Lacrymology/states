{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

package_build:
  pkg:
    - purged
    - pkgs:
      - debhelper
      - dpkg-dev
      - build-essential
      - fakeroot
