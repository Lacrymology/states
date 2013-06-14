{% set version = "0.9.0" %}
{% set roundcubedir = "/usr/local/roundcubemail-" + version %}

remove_roundcube_pgsql:
  postgres_user:
    - absent
    - name: roundcube
    - runas: postgres
  postgres_database:
    - absent
    - name: roundcube
    - runas: postgres

php5-pgsql:
  pkg:
    - purged

{{ roundcubedir }}:
  file:
    - absent

/etc/nginx/conf.d/roundcube.conf:
  file:
    - absent

/etc/uwsgi/roundcube.ini:
  file:
    - absent
