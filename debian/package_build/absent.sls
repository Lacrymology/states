{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

 -#}
package_build:
  pkg:
    - purged
    - pkgs:
      - debhelper
      - dpkg-dev
      - build-essential
      - fakeroot
