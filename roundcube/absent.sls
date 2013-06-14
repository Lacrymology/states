{% set pguser = salt['pillar.get']('roundcube:pguser', 'roundcube') %}
{% set pgdb = salt['pillar.get']('roundcube:pgdb', 'roundcubedb') %}
{% set version = "0.9.0" %}
{% set roundcubedir = "/usr/local/roundcubemail-" + version %}

remove_roundcube_pgsql:
  postgres_user:
    - absent
    - name: {{ pguser }}
    - runas: postgres
  postgres_database:
    - absent
    - name: {{ pgdb }}
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
