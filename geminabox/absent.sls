{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
/usr/local/geminabox:
  file:
    - absent

geminabox-uwsgi:
  file:
    - absent
    - purge: True
    - name: /etc/uwsgi/geminabox.yml

geminabox:
  user:
    - absent
    - force: True
    - require:
      - process: geminabox
  process:
    - wait_for_dead
    - name: ""
    - user: geminabox
    - require:
      - file: geminabox-uwsgi

/etc/nginx/conf.d/geminabox.conf:
  file:
    - absent

/var/lib/geminabox-data:
  file:
    - absent
    - require:
      - process: geminabox
