{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - name: /etc/php5/embed/conf.d/salt.ini

/usr/lib/{% if grains['cpuarch'] == 'i686' %}i386{% else %}x86_64{% endif %}-linux-gnu/libphp5-5.4.3-5uwsgi1.so:
  file:
    - absent

{#
    - require:
      - pkg: php-dev
#}
