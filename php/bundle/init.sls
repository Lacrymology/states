{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - php

php_bundle:
  pkg:
    - installed
    - pkgs:
      - php5-gd
      - php5-mysql
      - php5-mcrypt
      - php5-curl
    - require:
      - pkg: php
