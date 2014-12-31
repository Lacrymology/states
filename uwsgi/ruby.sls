{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
include:
  - ruby
  - uwsgi

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: ruby
    cmd:
      - watch:
        - pkg: ruby
