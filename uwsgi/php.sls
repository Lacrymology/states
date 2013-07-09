include:
  - apt
  - uwsgi

php-dev:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/lucid-php5 {{ grains['lsb_codename'] }} main
{%- else %}
    - ppa: l-mierzwa/lucid-php5
{%- endif %}
    - require:
      - pkg: python-apt
      - pkg: python-software-properties
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
      - pkgrepo: php-dev

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
