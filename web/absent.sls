web:
  user:
    - absent
    - name: www-data
  file:
    - absent
    - name: /var/www
    - require:
      - user: web
