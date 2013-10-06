include:
  - apt
  - java.7

openjdk_jdk:
  pkg:
    - installed
    - pkgs:
      - openjdk-7-jdk
    - require:
      - pkg: openjdk_jre_headless
      - cmd: apt_sources
