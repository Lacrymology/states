include:
  - nginx
  - apt
  - postgresql.server
  - uwsgi

{% set version = "0.9.0" %}
{% set roundcubedir = "/usr/local/roundcubemail-" + version %}

php5-pgsql:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

roundcube_create_db:
  cmd:
    - script
    - source: salt://roundcube/pgsqluser.sh
    - template: jinja
    - context:
      dir: {{ roundcubedir }}
    - require:
      - pkg: postgresql

roundcubemail_archive:
  archive:
    - extracted
    - name: /usr/local/
    - source: http://downloads.sourceforge.net/project/roundcubemail/roundcubemail/{{ version }}/roundcubemail-{{ version }}.tar.gz?r=&ts=1368775962&use_mirror=ncu
    - source_hash: md5=843de3439886c2dddb0f09e9bb6a4d04
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/roundcubemail-{{ version }}

{{ roundcubedir }}:
  file:
    - directory
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - archive: roundcubemail_archive

{% for file in ('db.inc.php','main.inc.php') %}
{{ roundcubedir}}/config/{{ file }}:
  file:
    - managed
    - source: salt://roundcube/{{ file }}
    - template: jinja
    - makedirs: True
{% endfor %}

{% for dir in 'logs','temp' %}
{{ roundcubedir }}/{{ dir }}:
  file:
    - directory
    - user: www-data
    - recurse:
      - user
    - require:
      - file: {{ roundcubedir }}
{% endfor %}

/etc/nginx/conf.d/roundcube.conf:
  file:
    - managed
    - source: salt://roundcube/nginx.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - context:
      dir: {{ roundcubedir }}
    - watch_in:
      - service: nginx

/etc/uwsgi/roundcube.ini:
  file:
    - managed
    - source: salt://roundcube/uwsgi.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - context:
      dir: {{ roundcubedir }}
