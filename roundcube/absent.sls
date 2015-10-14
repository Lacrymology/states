{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set is_test = salt['pillar.get']('__test__', False) %}
{%- set version = "1.0.1" %}
{% set roundcubedir = "/usr/local/roundcubemail-" + version %}

{%- if is_test %}
php5-pgsql:
  pkg:
    - purged

roundcube_password_plugin_ldap_driver_dependency:
  pkg:
    - purged
    - pkgs:
      - php5-cgi
      - php-net-ldap2
{%- endif %}

{{ roundcubedir }}:
  file:
    - absent

/etc/nginx/conf.d/roundcube.conf:
  file:
    - absent

roundcube-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/roundcube.yml

roundcube:
  user:
    - absent
    - require:
      - file: roundcube-uwsgi
  file:
    - absent
    - name: /var/lib/roundcube
    - require:
      - user: roundcube

{%- for suffix in ('', '-stats') %}
/var/lib/uwsgi/roundcube{{ suffix }}.sock:
  file:
    - absent
    - require:
      - file: roundcube-uwsgi
{%- endfor -%}
