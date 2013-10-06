include:
  - apt
  - java.6

openjdk_jdk:
  pkg:
    - installed
    - pkgs:
      - openjdk-6-jdk
    - require:
      - pkg: openjdk_jre_headless
      - cmd: apt_sources
