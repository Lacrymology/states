{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - php.dev

php_geoip:
  pkg:
    - installed
    - pkgs:
      - php5-geoip
      - libgeoip-dev
    - require:
      - cmd: apt_sources
      - pkg: php-dev
