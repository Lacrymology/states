{#- Usage of this is governed by a license that can be found in doc/license.rst #}
{%- from "upstart/absent.sls" import upstart_absent with context %}
{{ upstart_absent("countly_api") }}
{{ upstart_absent("countly_dashboard") }}

/usr/local/countly:
  file:
    - absent
    - require:
      - service: countly_api
      - service: countly_dashboard

/var/lib/countly:
  file:
    - absent
    - require:
      - service: countly_api
      - service: countly_dashboard

/etc/nginx/conf.d/countly.conf:
  file:
    - absent
    - require_in:
      - service: countly_api
      - service: countly_dashboard
