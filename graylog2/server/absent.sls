{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Uninstall a Graylog2 logging server backend
 -#}
{% set version = '0.11.0' %}
{% set server_root_dir = '/usr/local/graylog2-server-' + version %}

graylog2-server:
  service:
    - dead

{% for file in ('/etc/graylog2.conf', server_root_dir, '/etc/graylog2-elasticsearch.yml', '/etc/init/graylog2-server.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog2-server
{% endfor %}
