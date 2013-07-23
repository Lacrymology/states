include:
  - php

php_bundle:
  pkg:
    - installed
    - pkgs:
      - php5_gd
      - php5_mysql
      - php5_mcrypt
      - php5_curl
      - php5_cli
    - require:
      - pkgrepo: php
