{#-
 Unistalling GitLab
#}
{%- set version = '6-0' %}
{%- set web_dir = "/usr/local/gitlabhq-" + version + "-stable"  %}

git:
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

/etc/uwsgi/gitlab.ini:
  file:
    - absent

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', web_dir, '/home/git', '/etc/init/gitlab.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/gitlab.ini
{%- endfor %}
