include:
  - apt
  - php.dev
  - uwsgi

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: php-dev
{% if grains['cpuarch'] == 'i686' and grains['osrelease']|float == 12.04 %}
    cmd:
      - watch:
        - file: /usr/lib/i386-linux-gnu/libphp5.so
{% endif %}
