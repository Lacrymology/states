{# incomplete #}

/etc/apache2/conf.d/server-name:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://apache/config.jinja2
