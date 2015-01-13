{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

#}
include:
  - bash
  - local

{# manage a script which creates a dumb file and print new created filename #}
/usr/local/bin/create_dumb:
  file:
    - managed
    - source: salt://backup/create_dumb.jinja2
    - mode: 755
    - template: jinja
    - require:
      - file: /usr/local
      - file: bash
