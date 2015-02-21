{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
