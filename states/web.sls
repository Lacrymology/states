{#
 Minimal state for any web-based running apps
 #}
web:
  group:
    - present
    - name: www-data
    - system: True
  user:
    - present
    - name: www-data
    - gid_from_name: True
    - system: True
    - fullname: www-data
    - shell: /bin/false
    - home: /var/www
    - password: "*"
    - enforce_password: True
    - require:
      - group: web
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 775
    - require:
      - user: web
      - group: web
