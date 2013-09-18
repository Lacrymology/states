{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 State(s) common to graylog2 web and server
 -#}

include:
  - web

/var/log/graylog2:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 770
    - makedirs: True
    - require:
      - user: web
