include:
  - diamond
  - nrpe

/etc/nginx/conf.d/default.conf:
  file.absent

/etc/nginx/conf.d/example_ssl.conf:
  file.absent

/etc/nagios/nrpe.d/nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe.jinja2

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
    - name: /etc/nginx/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/config.jinja2
    - require:
      - pkg: nginx
  service:
    - running
    - watch:
      - file: nginx
      - file: /etc/nginx/conf.d/default.conf
      - file: /etc/nginx/conf.d/example_ssl.conf
      - pkg: nginx

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
      - file: nginx

extend:
  diamond:
    service:
      - watch:
        - file: nginx_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/nginx.cfg
