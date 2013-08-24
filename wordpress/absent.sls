{#-
  Uninstall Wordpress
#}
{%- set version = "3.5.2" %}
{%- set wordpressdir = "/usr/local/wordpress-" + version %}

wordpress:
  file:
    - absent
    - name: {{ wordpressdir }}

{%- for file in ('/etc/nginx/conf.d/wordpress.conf', '/etc/uwsgi/wordpress.ini')  %}
{{ file }}:
  file:
    - absent
{%- endfor %}
