include:
  - diamond
  - nrpe

{% for filename in ('default', 'example_ssl') %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file.absent
{% endfor %}

/etc/nagios/nrpe.d/nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe.jinja2

/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/config.jinja2
    - require:
      - pkg: nginx

nginx-old-init:
  file:
    - rename
    - name: /usr/share/nginx/init.d
    - source: /etc/init.d/nginx
    - require:
      - pkg: nginx
  cmd:
    - wait
    - name: dpkg-divert --divert /usr/share/nginx/init.d --add /etc/init.d/nginx
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init
  module:
    - wait
    - name: cmd.run
    - cmd: kill `cat /var/run/nginx.pid`
    - watch:
      - file: nginx-old-init

nginx-old-init-disable:
  cmd:
    - wait
    - name: update-rc.d -f nginx remove
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init

{% set logger_types = ('access', 'error') %}

{% for log_type in logger_types %}
/var/log/nginx/{{ log_type }}.log:
  file.absent

nginx-logger-{{ log_type }}:
  file:
    - managed
    - name: /etc/init/nginx-logger-{{ log_type }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/upstart_logger.jinja2
    - context:
      type: {{ log_type }}
  service:
    - running
    - enable: True
    - require:
      - file: nginx-logger-{{ log_type }}
      - pkg: nginx
{% endfor %}

/etc/logrotate.d/nginx:
  file:
    - absent

nginx:
  apt_repository:
    - present
    - address: http://nginx.org/packages/ubuntu/
    - components:
      - nginx
    - key_server: subkeys.pgp.net
    - key_id: 7BD9BF62
  pkg:
    - latest
    - name: nginx
    - require:
      - apt_repository: nginx
  file:
    - managed
    - name: /etc/init/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/upstart.jinja2
    - require:
      - pkg: nginx
      - file: nginx-old-init
      - module: nginx-old-init
  service:
    - running
    - enable: True
    - watch:
      - file: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/default.conf
      - file: /etc/nginx/conf.d/example_ssl.conf
      - pkg: nginx
    - require:
{% for log_type in logger_types %}
      - service: nginx-logger-{{ log_type }}
{% endfor %}

nginx_diamond_memory:
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
    - source: salt://nginx/diamond.jinja2
    - require:
      - service: nginx

extend:
  diamond:
    service:
      - watch:
        - file: nginx_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/nginx.cfg
