{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
jre-7:
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - pkgs:
      - openjdk-7-jre-headless
      - default-jre
#}
  cmd:
    - run
    - name: sed -i '\:/usr/lib/jvm/java-7-openjdk:d' /etc/environment

jre-7-i386:
  file:
    - absent
    - name: /usr/lib/jvm/java-7-openjdk
