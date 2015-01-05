{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Dang Tung Lam <lam@robotinfra.com>
-#}
php-dev:
{#-
  Can't uninstall these packages as they're used by others
  pkg:
    - purged
    - pkgs:
      - php5-dev
      - libphp5-embed
      - php-config
    - require:
      - file: php-dev
#}
  file:
    - absent
    - name: /etc/php5/conf.d/salt.ini

/usr/lib/{% if grains['cpuarch'] == 'i686' %}i386{% else %}x86_64{% endif %}-linux-gnu/libphp5-5.4.3-5uwsgi1.so:
  file:
    - absent

{#
    - require:
      - pkg: php-dev
#}
