{#
 Minimal state for any web-based running apps
 #}
web:
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
  file:
    - directory
    - name: /var/lib/deployments
    - user: www-data
    - group: www-data
    - mode: 775
    - require:
      - user: web
