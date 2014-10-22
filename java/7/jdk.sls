include:
  - apt
  - java.7

jdk-7:
  pkg:
    - installed
    - name: openjdk-7-jdk
    - require:
      - pkg: jre-7
      - cmd: apt_sources
