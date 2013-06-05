libphp5_embed_repo:
  pkgrepo:
    - managed
    - ppa: l-mierzwa/lucid-php5
    - name: deb http://ppa.launchpad.net/l-mierzwa/lucid-php5/ubuntu precise main

uwsgi_require_for_php:
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
      - pkgrepo: libphp5_embed_repo

/usr/lib/i386-linux-gnu/libphp5.so:
  file:
    - symlink
    - target: /usr/lib/php5/libphp5-5.4.3-5uwsgi1.so
    - require:
      - pkg: uwsgi_require_for_php
