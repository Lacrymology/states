{#-
 Unistalling GitLab
#}
{%- set version = '6-0' %}
{%- set root_dir = "/usr/local"  %}
{%- set web_dir = root_dir + "/gitlabhq-" + version + "-stable"  %}

git:
  user:
    - absent
    - force: True
  group:
    - absent
    - require:
      - user: git
  cmd:
    - run
    - name: RAILS_ENV=production bundle exec rake sidekiq:stop
    - cwd: {{ web_dir }}

/etc/uwsgi/gitlab.ini:
  file:
    - absent

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', root_dir, '/home/git', '/etc/init/gitlab.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/gitlab.ini
{%- endfor %}
