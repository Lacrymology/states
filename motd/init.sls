{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Setup motd (message of the day)
 http://en.wikipedia.org/wiki/Motd_(Unix)
 -#}
/etc/update-motd.d/10-help-text:
  file:
     - absent

/etc/motd.tail:
   file:
     - managed
     - template: jinja
     - user: root
     - group: root
     - mode: 444
     - source: salt://motd/config.jinja2
   cmd:
     - wait
     - name: run-parts /etc/update-motd.d/ > /etc/motd
     - watch:
       - file: /etc/update-motd.d/10-help-text
       - file: /etc/motd.tail
