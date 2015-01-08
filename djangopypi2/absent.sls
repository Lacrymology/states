{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/etc/nginx/conf.d/djangopypi2.conf:
  file:
    - absent

djangopypi2-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/djangopypi2.yml
    - require:
      - file: /etc/nginx/conf.d/djangopypi2.conf

/usr/local/djangopypi2:
  file:
    - absent
    - require:
      - file: djangopypi2-uwsgi

/var/lib/deployments/djangopypi2:
  file:
    - absent
    - require:
      - file: djangopypi2-uwsgi
