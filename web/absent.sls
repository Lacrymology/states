{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - name: /var/lib/deployments
    - require:
      - user: web

/var/www:
  file:
    - absent
    - require:
      - user: web
