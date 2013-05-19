#apache2:
#  pkg:
#    - installed
#    - pkgs:
#      - apache2
#      - libapache2-mod-php5

php5-fpm:
  pkg:
    - installed

php5:
  pkg:
    - installed

php5-pgsql:
  pkg:
    - installed

postgresql-9.1:
  pkg:
    - installed

roundcube_create_db:
  cmd:
    - script
    - source: salt://roundcube/pgsqluser.sh

{% set version = "0.9.0" %}
/usr/local/src/roundcubemail-{{ version }}.tar.gz:
  file:
    - managed
    - source: http://downloads.sourceforge.net/project/roundcubemail/roundcubemail/{{ version }}/roundcubemail-{{ version }}.tar.gz?r=&ts=1368775962&use_mirror=ncu
    - source_hash: md5=843de3439886c2dddb0f09e9bb6a4d04

tar xzf /usr/local/src/roundcubemail-{{ version }}.tar.gz:
  cmd:
    - run
    - cwd: /usr/local
    - unless: test -d /usr/local/roundcubemail-{{ version }}/

/usr/local/src/roundcubemail-{{ version }}:
  file:
    - directory
    - user: root
    - group: root
    - recurse:
      - user
      - group

{% for file in ('db.inc.php','main.inc.php') %}
/usr/local/roundcubemail-0.9.0/config/{{ file }}:
  file:
    - managed
    - source: salt://roundcube/{{ file }}
    - template: jinja
    - makedirs: True
{% endfor %}

{% for dir in 'logs','temp' %}
/usr/local/roundcubemail-0.9.0/{{ dir }}:
  file:
    - directory
    - user: www-data
    - recurse:
      - user
    - require:
      - file: /usr/local/src/roundcubemail-{{ version }}
{% endfor %}
