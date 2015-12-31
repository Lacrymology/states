{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('mattermost') }}

/usr/local/mattermost:
  file:
    - absent
    - require:
      - service: mattermost

mattermost_user:
  user:
    - absent
    - name: mattermost
    - require:
      - service: mattermost

/etc/mattermost.json:
  file:
    - absent
    - require:
      - service: mattermost

/var/lib/mattermost:
  file:
    - absent
    - require:
      - service: mattermost

/var/log/mattermost:
  file:
    - absent
    - require:
      - service: mattermost

/etc/nginx/conf.d/mattermost.conf:
  file:
    - absent
    - require:
      - service: mattermost
