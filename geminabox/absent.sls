{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
/usr/local/geminabox:
  file:
    - absent

geminabox-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/geminabox.yml

geminabox:
  user:
    - absent
    - force: True
    - purge: True
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

{# workaround userdel bug logs error if it cannot delete mail dir of that user
This create fake one for those users to avoid error log when user.absent runs #}
geminabox_fake_mail_path:
  file:
    - managed
    - name: /var/mail/geminabox
    - makedirs: True
    - replace: False
    - require:
      - process: geminabox
    - require_in:
      - user: geminabox
