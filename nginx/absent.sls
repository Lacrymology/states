{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('nginx') }}

nginx-old-init:
  cmd:
    - wait
    - name: dpkg-divert --rename --remove /etc/init.d/nginx
    - watch:
      - file: nginx-old-init
  file:
    - absent
    - name: /usr/share/nginx/init.d

extend:
  nginx:
    pkg:
      - purged
      - require:
        - service: nginx
        - file: nginx-old-init
    user:
      - absent
      - require:
        - pkg: nginx

{% for type in ('etc', 'var/log', 'etc/logrotate.d') %}
/{{ type }}/nginx:
  file:
    - absent
    - require:
      - pkg: nginx
{% endfor %}

/var/www/robots.txt:
  file:
    - absent
