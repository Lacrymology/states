{#
 Uninstall the Nginx web server
 #}
nginx-old-init:
  cmd:
    - run
    - name: dpkg-divert --rename --remove /etc/init.d/nginx
  file:
    - absent
    - name: /usr/share/nginx/init.d
    - require:
      - cmd: nginx-old-init

nginx:
  file:
    - absent
    - name: /etc/init/nginx.conf
    - require:
      - service: nginx
  pkg:
    - purged
    - require:
      - service: nginx
      - file: nginx-old-init
  service:
    - dead

{% for type in ('etc', 'var/log', 'etc/logrotate.d') %}
/{{ type }}/nginx:
  file:
    - absent
    - require:
      - pkg: nginx
{% endfor %}

{% for log_type in ('access', 'error') %}
nginx-logger-{{ log_type }}:
  file:
    - absent
    - name: /etc/init/nginx-logger-{{ log_type }}.conf
    - require:
      - service: nginx-logger-{{ log_type }}
  service:
    - dead
{% endfor %}
