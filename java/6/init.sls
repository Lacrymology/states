{#
 Install Java
 #}
include:
  - apt

openjdk_jre_headless:
  pkg:
    - installed
    - name: openjdk-6-jre-headless
    - require:
      - cmd: apt_sources
      - file: append_java_path


append_java_path:
  file:
    - append
    - name: /etc/environment
    - text: |
        export JAVA_HOME="/usr/lib/jvm/java-6-openjdk-amd64"
        export JRE_HOME="/usr/lib/jvm/java-6-openjdk-amd64/jre"
