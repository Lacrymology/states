php5-fpm:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - running
    - watch:
      - file: php5-fpm
      - file: /etc/php5/fpm/php-fpm.conf
  file:
    - managed
    - template: jinja
    - name: /etc/php5/fpm/pool.d/www.conf
    - source: salt://php5-fpm/pool.jinja2
    - require:
      - pkg: php5-fpm

/etc/php5/fpm/php-fpm.conf:
  file:
    - managed
    - template: jinja
    - source: salt://php5-fpm/config.jinja2
    - require:
      - pkg: php5-fpm
