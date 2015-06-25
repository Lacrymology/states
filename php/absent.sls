{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}
{%- from "php/map.jinja2" import php with context %}

php:
  file:
    - absent
    - name: /etc/apt/sources.list.d/php.list
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - name: php5
#}
  cmd:
    - run
    - name: 'apt-key del 67E15F46'
    - onlyif: apt-key list | grep -q 67E15F46

php-5.6:
  cmd:
    - run
    - name: apt-key del E5267A6C
    - onlyif: apt-key list | grep -q E5267A6C

{#-
libedit2 is upgraded to 3.11 from PHP 5.6 repository, reverted it to official version
#}
official-libedit2:
  cmd:
    - wait
    - name: |
        apt-get -y --force-yes install libedit2=$(apt-cache show libedit2 | sed -n  -e '/deb\.sury.\org/d' -e '/^Version: /s///p' | sed -e '1!d')
    - watch:
      - file: php

/etc/pear:
  file:
    - absent

{%- set pkgs = salt["pkg.list_pkgs"]() %}
{%- if "php5-common" in pkgs and salt["pkg.version_cmp"](pkgs["php5-common"], "5.5.0") == 1 %}
{#- lucid-php < 5.5 will fail to remove if this directory is missing #}
/etc/php5:
  file:
    - absent
{%- endif %}
