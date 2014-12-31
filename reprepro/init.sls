{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - web

reprepro:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - directory
    - name: /var/lib/reprepro
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - user: web
