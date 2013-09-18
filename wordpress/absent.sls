{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
  Uninstall Wordpress
-#}

{%- set wordpressdir = "/usr/local/wordpress" %}

wordpress:
  file:
    - absent
    - name: {{ wordpressdir }}

{%- for file in ('/etc/nginx/conf.d/wordpress.conf', '/etc/uwsgi/wordpress.ini')  %}
{{ file }}:
  file:
    - absent
{%- endfor %}
