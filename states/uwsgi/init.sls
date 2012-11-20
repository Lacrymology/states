
uwsgi:
  pkg:
    - installed
    - names:
      - uwsgi
      - uwsgi-plugin-ping
      - uwsgi-plugin-python
      - uwsgi-plugin-syslog
  service:
    - running
