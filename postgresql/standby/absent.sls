{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - postgresql.server.absent

{% set version="9.2" %}

/var/lib/postgresql/{{ version }}/main/recovery.conf:
  file:
    - absent
    - require:
      - service: postgresql
