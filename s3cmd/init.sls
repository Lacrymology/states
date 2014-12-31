{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - apt

s3cmd:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

/root/.s3cfg:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://s3cmd/config.jinja2
    - require:
      - pkg: s3cmd
