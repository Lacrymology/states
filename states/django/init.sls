include:
  - nrpe

/usr/local/bin/check_robots.py:
  file:
    - managed
    - user: nagios
    - group: nagios
    - mode: 550
    - source: salt://django/check_robots.py
    - require:
      - pkg: nagios-nrpe-server
