{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
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
    - name: /etc/php5/embed/conf.d/salt.ini
    - source: salt://php/config.jinja2
    - template: jinja
    - require:
      - pkg: php-dev
