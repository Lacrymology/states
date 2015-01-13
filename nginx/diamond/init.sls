{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - diamond
  - nginx
  - rsyslog.diamond

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
    - watch_in:
      - service: diamond

extend:
  diamond:
    service:
      - require:
        - service: nginx
