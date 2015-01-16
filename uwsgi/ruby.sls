{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
