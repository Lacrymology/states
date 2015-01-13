{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Uninstall a Sentry web server.
-#}
sentry-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/sentry.yml
    - require:
      - file: /etc/nginx/conf.d/sentry.conf

/etc/sentry.conf.py:
  file:
    - absent
    - require:
      - file: sentry-uwsgi

/usr/local/sentry:
  file:
    - absent
    - require:
      - file: sentry-uwsgi

/etc/nginx/conf.d/sentry.conf:
  file:
    - absent

/var/lib/deployments/sentry:
  file:
    - absent
