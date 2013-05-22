{#
 Uninstall a Sentry web server.
 #}

{#
{% if pillar['destructive_absent']|default(False) and salt['pillar.get']('sentry:db', False) %}
include:
  - postgresql.server

sentry:
  postgres_database:
    - absent
    - name: {{ pillar['sentry']['db']['name'] }}
    - runas: postgres
    - require:
      - service: postgresql
      - file: /etc/uwsgi/sentry.ini
  postgres_user:
    - absent
    - name: {{ pillar['sentry']['db']['username'] }}
    - runas: postgres
    - require:
      - service: postgresql
      - postgres_database: sentry
{% endif %}
#}

/etc/uwsgi/sentry.ini:
  file:
    - absent

/etc/sentry.conf.py:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/sentry.ini

/usr/local/sentry:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/sentry.ini

/etc/nginx/conf.d/sentry.conf:
  file:
    - absent
