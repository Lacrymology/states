{#
 Install Java
 #}
include:
  - apt

openjdk_jre_headless:
  pkg:
    - installed
{% if grains['osrelease'] in ('12.04', '12.10', '13.04') %}
    - name: openjdk-7-jre-headless
{% else %}
    - name: openjdk-6-jre-headless
{% endif %}
    - require:
      - cmd: apt_sources
