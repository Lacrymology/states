{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

{{ opts['cachedir'] }}/pip/djangopypi2:
  file:
    - absent
