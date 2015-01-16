{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Install Java.
-#}
include:
  - apt

jre-7:
  pkg:
    - installed
    - name: openjdk-7-jre-headless
    - require:
      - cmd: apt_sources
      - file: jre-7
  file:
    - append
    - name: /etc/environment
    - text: |
        export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-{{ grains['debian_arch'] }}"
        export JRE_HOME="/usr/lib/jvm/java-7-openjdk-{{ grains['debian_arch'] }}/jre"

{%- if grains['cpuarch'] == 'i686' %}
jre-7-i386:
  file:
    - symlink
    - name: /usr/lib/jvm/java-7-openjdk
    - target: /usr/lib/jvm/java-7-openjdk-i386
    - require:
      - pkg: jre-7
{%- endif -%}
