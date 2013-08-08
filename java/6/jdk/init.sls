include:
  - apt
  - java.6

openjdk_jdk:
  pkg:
    - installed
    - name: openjdk-6-jdk
    - require:
      - pkg: openjdk_jre_headless
      - pkg: openjdk_jre
      - cmd: apt_sources

openjdk_jre:
  pkg:
    - installed
    - name: openjdk-6-jre
    - require:
      - pkg: openjdk_jre_headless
      - cmd: apt_sources
