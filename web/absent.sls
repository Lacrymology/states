web:
  user:
    - absent
    - name: www-data
  group:
    - absent
    - name: www-data
    - require:
      - user: web
  file:
    - absent
    - name: /var/www
    - require:
      - group: web
      - user: web
