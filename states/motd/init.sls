{# TODO: use /etc/update-motd.d in precise #}
/etc/motd:
   file.managed:
     - template: jinja
     - user: root
     - group: root
     - mode: 644
     - source: salt://motd/motd.jinja2
