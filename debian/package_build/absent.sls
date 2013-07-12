debhelper:
  pkg:
    - purged

build-essential:
  pkg:
    - purged

package_build:
  pkg:
    - purged
    - name: dpkg-dev
    - require:
      - pkg: debhelper
      - pkg: build-essential
