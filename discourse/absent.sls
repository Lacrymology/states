{#-
Uninstall Discourse
#}

{%- set version = "0.9.6.3" %}
{%- set web_root_dir = "/usr/local/discourse-" + version %}

discourse:
  user:
    - absent
    - force: True
  group:
    - absent
    - require:
      - user: discourse
  service:
    - dead

{%- for file in (web_root_dir, '/home/discourse', '/etc/uwsgi/discourse.ini', '/etc/nginx/conf.d/discourse.conf', '/etc/logrotate.d/discourse', '/etc/init/discourse.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: discourse
{%- endfor %}
