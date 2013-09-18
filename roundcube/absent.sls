{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
{% set version = "0.9.0" %}
{% set roundcubedir = "/usr/local/roundcubemail-" + version %}

{{ roundcubedir }}:
  file:
    - absent

/etc/nginx/conf.d/roundcube.conf:
  file:
    - absent

/etc/uwsgi/roundcube.ini:
  file:
    - absent
