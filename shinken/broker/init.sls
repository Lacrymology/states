{#
 Shinken Broker state.

 The broker daemon exports and manages data from schedulers. The broker uses
 modules exclusively to get the job done.
 #}
include:
  - shinken
  - nginx
  - gsyslog
  - web
{% if pillar['shinken']['ssl']|default(False) %}
  - ssl
{% endif %}

/etc/nginx/conf.d/shinken-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://shinken/broker/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web

shinken-broker:
  file:
    - managed
    - name: /etc/init/shinken-broker.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: broker
  service:
    - running
    - enable: True
    - require:
      - file: /var/log/shinken
      - file: /var/lib/shinken
    - watch:
      - module: shinken
      - file: /etc/shinken/broker.conf
      - file: shinken-broker
      - service: gsyslog

/etc/shinken/broker.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: broker
    - require:
      - file: /etc/shinken
      - user: shinken

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/shinken-web.conf
{% if pillar['shinken']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['shinken']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['shinken']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['shinken']['ssl'] }}/ca.crt
{% endif %}
