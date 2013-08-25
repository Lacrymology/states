{#-
 Unistalling GitLab
#}
{%- set version = '6-0' %}
{%- set web_dir = "/usr/local/gitlabhq-" + version + "-stable"  %}

gitlab:
  user:
    - absent
    - force: True
    - require:
      - cmd: git
  group:
    - absent
    - require:
      - user: git
  cmd:
    - run
    - name: RAILS_ENV=production bundle exec rake sidekiq:stop
    - user: git
    - cwd: {{ web_dir }}

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', web_dir, '/home/git', '/etc/init/gitlab.conf', '/etc/uwsgi/gitlab.ini') %}
{{ file }}:
  file:
    - absent
{%- endfor %}
