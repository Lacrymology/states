{#
 Turn off Diamond statistics for PostgreSQL Server
#}
{% if 'graphite_address' in pillar %}
include:
  - diamond

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
    - absent
  postgres_user:
    - absent
    - runas: postgres
    - require:
      - postgres_database: postgresql_diamond_collector
  postgres_database:
    - absent
    - name: diamond
    - runas: postgres
