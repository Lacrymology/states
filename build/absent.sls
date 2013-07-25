build:
  pkg:
    - purged
    - name: gcc
    - require:
      - pkg: g++
      - pkg: make

g++:
  pkg:
    - purged

make:
  pkg:
    - purged
