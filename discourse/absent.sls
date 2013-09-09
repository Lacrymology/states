{#-
Uninstall Discourse
#}

{%- set web_root_dir = "/usr/local/discourse-master" %}

discourse:
  user:
    - absent
    - force: True
  group:
    - absent
    - require:
      - user: discourse

{%- for file in (web_root_dir, '/home/discourse', '/etc/uwsgi/discourse.ini', '/etc/nginx/conf.d/discourse.conf') %}
{{ file }}:
  file:
    - absent

{%- endfor %}
