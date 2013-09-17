{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Diamond statistics for Nginx
-#}
include:
  - diamond
  - rsyslog.diamond
  - nginx

nginx_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nginx]]
        exe = ^\/usr\/sbin\/nginx$
        cmdline = ^logger \-f \/var\/log\/nginx

nginx_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/NginxCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors

extend:
  diamond:
    service:
      - watch:
        - file: nginx_diamond_collector
      - require:
        - service: nginx
