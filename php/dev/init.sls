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

{% if grains['cpuarch'] == 'i686' and grains['osrelease']|float == 12.04 %}
/usr/lib/i386-linux-gnu/libphp5.so:
  file:
    - symlink
    - target: /usr/lib/php5/libphp5.so
    - require:
      - pkg: php-dev
{% endif %}
