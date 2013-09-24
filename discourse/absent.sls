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
  cmd:
    - run
    - name: kill -9 $(ps -ef | grep sidekiq | grep -v grep | awk  '{print $2}')
    - user: root
    - onlyif: ps -ef | grep sidekiq | grep -v grep
    {#-
    - env:
        RAILS_ENV: production
    - cwd: {{ web_root_dir }}
    - onlyif: ps -ef | grep sidekiqctl | grep -v grep
    #}

{%- for file in (web_root_dir, '/home/discourse', '/etc/uwsgi/discourse.ini', '/etc/nginx/conf.d/discourse.conf', '/etc/logrotate.d/discourse', '/etc/init/discourse.conf', '/var/log/sidekiq.log') %}
{{ file }}:
  file:
    - absent
    - require:
      - cmd: discourse
{%- endfor %}
