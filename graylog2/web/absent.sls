{#
 Uninstall a graylog2 web interface server
#}
{% set version = '0.11.0' %}
{% set web_root_dir = '/usr/local/graylog2-web-interface-' + version %}

{# TODO: uninstall ruby stuff #}

/etc/logrotate.d/graylog2-web:
  file:
    - absent

{% for file in ('/etc/nginx/conf.d/graylog2-web.conf', web_root_dir, '/etc/init/graylog2-web.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graylog2.ini
{% endfor %}

/etc/uwsgi/graylog2.ini:
  file:
    - absent

{% for command in ('streamalarms', 'subscriptions') %}
/etc/cron.hourly/graylog2-web-{{ command }}:
  file:
    - absent
{% endfor %}
