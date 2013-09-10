{#
 Backup for Gitlab
 #}
include:
  - cron

{%- set version = '6-0' %}
{%- set web_dir = "/usr/local/gitlabhq-" + version + "-stable"  %}
/etc/cron.daily/backup-discourse:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://discourse/backup/cron.jinja2
    - require:
      - pkg: cron
    - context:
      web_dir: {{ web_root_dir }}
