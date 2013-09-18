{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Install Java
 -#}
include:
  - apt

openjdk_jre_headless:
  pkg:
    - installed
    - name: openjdk-7-jre-headless
    - require:
      - cmd: apt_sources
      - file: append_java_path

append_java_path:
  file:
    - append
    - name: /etc/environment
    - text: |
        export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-{{ grains['debian_arch'] }}"
        export JRE_HOME="/usr/lib/jvm/java-7-openjdk-{{ grains['debian_arch'] }}/jre"
