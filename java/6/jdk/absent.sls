openjdk_jdk:
  pkg:
    - purged
    - name: openjdk-6-jdk

{#- this pkg need to be removed, or openjdk_jre_headless cannot be removed #}
openjdk-6-jre:
  pkg:
    - purged
    - require:
      - pkg: openjdk_jdk
