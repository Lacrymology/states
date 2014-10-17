include:
  - apt
  - java.6

jdk-6:
  pkg:
    - installed
    - pkgs:
      - openjdk-6-jdk
    - require:
      - pkg: jre-6
      - cmd: apt_sources
