{#
 Uninstall the web interface component of graphite
 #}
include:
  - nginx
{% if pillar['destructive_absent']|default(False) %}
include:
  - postgresql.server

graphite-database:
  postgres_user:
    - absent
    - name: {{ pillar['graphite']['web']['db']['name'] }}
    - runas: postgres
    - require:
      - service: postgresql
      - postgres_database: graphite-database
  postgres_database:
    - present
    - name: {{ pillar['graphite']['web']['db']['name'] }}
    - runas: postgres
    - require:
      - service: postgresql
{% endif %}

/etc/uwsgi/graphite.ini:
  file:
    - absent

{% for file in ('/var/log/graphite/graphite', '/etc/graphite/graphTemplates.conf', '/etc/nginx/conf.d/graphite.conf') %}
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graphite.ini
{% endfor %}

{% for local in ('manage', 'salt-graphite-web-requirements.txt', 'bin/build-index.sh') %}
/usr/local/graphite/{{ local }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graphite.ini
{% endfor %}

{% for module in ('wsgi.py', 'local_settings.py') %}
/usr/local/graphite/lib/python2.7/site-packages/graphite/{{ module }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graphite.ini
{% endfor %}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/graphite.conf
