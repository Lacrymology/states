include:
  - apt
  - uwsgi

php-dev:
  apt_repository:
    - ubuntu_ppa
    - user: l-mierzwa
    - name: lucid-php5
    - key_id: 67E15F46
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
      - apt_repository: php-dev

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: php-dev
{% if grains['cpuarch'] == 'i686' and grains['osrelease']|float == 12.04 %}
    cmd:
      - watch:
        - file: /usr/lib/i386-linux-gnu/libphp5.so

/usr/lib/i386-linux-gnu/libphp5.so:
  file:
    - symlink
    - target: /usr/lib/php5/libphp5.so
    - require:
      - pkg: php-dev
{% endif %}
