{#
 Turn off Diamond statistics for PostgreSQL Server
#}
include:
  - postgresql.server
{% if 'graphite_address' in pillar %}
  - diamond

{# TODO: uninstall psycopg2 from diamond virtualenv #}

extend:
  diamond:
    service:
      - watch:
        - file: postgresql_diamond_collector
{% endif %}

/usr/local/diamond/salt-postgresql-requirements.txt:
  file:
    - absent

postgresql_diamond_collector:
  file:
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - absent
  postgres_user:
    - absent
    - runas: postgres
    - require:
      - postgres_database: postgresql_diamond_collector
      - service: postgresql
  postgres_database:
    - absent
    - name: diamond
    - runas: postgres
    - require:
      - service: postgresql
