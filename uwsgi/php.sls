libphp5_embed_repo:
  pkgrepo:
    - managed
    - ppa: ppa:l-mierzwa/lucid-php5

uwsgi_require_for_php:
  pkg:
    - installed
    - pkgs:
      - libdb-dev
      - libbz2-dev
      - libgssapi-krb5-2
      - libkrb5-dev
      - libk5crypto3
      - libphp5-embed
      - libcomerr2
      - libzip-dev
      - libpcre3-dev
      - php5-dev
      - libphp5-embed
      - libonig-dev
      - libqdbm-dev
    - require:
      - pkgrepo: libphp5_embed_repo
