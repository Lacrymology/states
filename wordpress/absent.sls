{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

wordpress:
  file:
    - absent
    - name: /usr/local/wordpress

wordpress_uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/wordpress.yml

/etc/nginx/conf.d/wordpress.conf:
  file:
    - absent

/etc/logrotate.d/wordpress:
  file:
    - absent
