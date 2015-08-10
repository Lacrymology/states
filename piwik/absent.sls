{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

piwik:
  pkg:
    - purged

/etc/uwsgi/piwik.yml:
  file:
    - absent

/etc/nginx/conf.d/piwik.conf:
  file:
    - absent
