include:
  - apt
  - java.6

openjdk_jdk:
  pkg:
    - installed
    - pkgs:
      - openjdk-6-jdk
      - openjdk-6-jre
    - require:
      - pkg: openjdk_jre_headless
      - cmd: apt_sources
