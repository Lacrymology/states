djangopypi2:
  file:
    - absent
    - name: /usr/local/djangopypi2

/var/lib/djangopypi2:
  file:
    - absent

/etc/uwsgi/djangopypi2.ini:
  file:
    - absent

/etc/nginx/conf.d/djangopypi2.conf:
  file:
    - absent
