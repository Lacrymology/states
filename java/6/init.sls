{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

jre-6:
  pkg:
    - installed
    - name: openjdk-6-jre-headless
    - require:
      - cmd: apt_sources
      - file: jre-6
  file:
    - append
    - name: /etc/environment
    - text: |
        export JAVA_HOME="/usr/lib/jvm/java-6-openjdk-{{ grains['osarch'] }}"
        export JRE_HOME="/usr/lib/jvm/java-6-openjdk-{{ grains['osarch'] }}/jre"
