{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Install Java.
-#}
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
        export JAVA_HOME="/usr/lib/jvm/java-6-openjdk-{{ grains['debian_arch'] }}"
        export JRE_HOME="/usr/lib/jvm/java-6-openjdk-{{ grains['debian_arch'] }}/jre"
