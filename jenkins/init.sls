{#
  TODO: add SSL through nginx
#}

include:
  - apt
  - nginx
{% if pillar['jenkins']['web']['ssl']|default(False) %}
  - ssl
{% endif %}

jenkins:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

/etc/nginx/conf.d/jenkins.conf:
  file:
    - managed
    - template: jinja
    - source: salt://jenkins/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/jenkins.conf
{% if pillar['jenkins']['web']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['jenkins']['web']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['jenkins']['web']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['jenkins']['web']['ssl'] }}/ca.crt
{% endif %}