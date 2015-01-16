{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
web:
  user:
    - absent
    - name: www-data
  group:
    - absent
    - name: www-data
    - require:
      - user: web
  file:
    - absent
    - name: /var/lib/deployments
    - require:
      - user: web

/var/www:
  file:
    - absent
    - require:
      - user: web
