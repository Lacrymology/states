{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org

 Backup client for Discourse
 -#}
include:
  - cron
{%- set web_root_dir = "/usr/local/discourse" %}
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
      web_root_dir: {{ web_root_dir }}
