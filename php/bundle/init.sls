{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Dang Tung Lam <lam@robotinfra.com>
-#}
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
      - php5-cli
    - require:
      - pkgrepo: php
