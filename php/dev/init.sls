{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
      - pkg: php
  file:
    - managed
    - name: /etc/php5/embed/conf.d/salt.ini
    - source: salt://php/config.jinja2
    - mode: 444
    - template: jinja
    - require:
      - pkg: php-dev
