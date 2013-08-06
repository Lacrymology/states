openjdk-7-jdk:
  pkg:
    - purged

openjdk-7-jre:
  pkg:
    - purged
    - require:
      - pkg: openjdk-7-jdk
