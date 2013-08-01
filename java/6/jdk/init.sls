include:
  - java.6

openjdk_jdk:
  pkg:
    - installed
    - name: openjdk-6-jdk
    - require:
      - pkg: openjdk_jre_headless
