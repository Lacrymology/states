{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

jre-6:
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - pkgs:
      - openjdk-6-jre-headless
      - default-jre
#}
  cmd:
    - run
    - name: sed -i '\:/usr/lib/jvm/java-6-openjdk:d' /etc/environment
