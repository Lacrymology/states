/etc/uwsgi/moinmoin.ini:
  file:
    - absent

/usr/local/moinmoin:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/moinmoin.ini

/etc/nginx/conf.d/moinmoin.conf:
  file:
    - absent
