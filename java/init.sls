{#
 Install Java
 #}
include:
  - apt

openjdk_jre_headless:
  pkg:
    - installed
{% if grains['osrelease']|float < 12.04 %}
    - name: openjdk-6-jre-headless
{% else %}
    - name: openjdk-7-jre-headless
{% endif %}
    - require:
      - cmd: apt_sources
