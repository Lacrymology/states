{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - php

php-dev:
  pkg:
    - installed
    - pkgs:
      - libdb-dev
      - libbz2-dev
      - libgssapi-krb5-2
      - libkrb5-dev
      - libk5crypto3
      - libcomerr2
      - libzip-dev
      - libpcre3-dev
      - libphp5-embed
      - libonig-dev
      - libqdbm-dev
      - php5-dev
      - php-config
    - require:
      - pkgrepo: php
  file:
    - managed
    - name: /etc/php5/conf.d/salt.ini
    - source: salt://php/config.jinja2
    - mode: 444
    - template: jinja
    - require:
      - pkg: php-dev
