{#-
 Unistalling GitLab
#}
{%- set version = '6-0' %}
{%- set root_dir = "/usr/local/gitlab"  %}
{%- set web_dir = root_dir + "/gitlabhq-" + version + "-stable"  %}

git:
  user:
    - absent
    - force: True
  group:
    - absent
    - require:
      - user: git

/etc/uwsgi/gitlab.ini:
  file:
    - absent

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', root_dir, '/home/git') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/gitlab.ini

{%- endfor %}
