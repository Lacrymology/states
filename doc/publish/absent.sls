{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/usr/local/salt-doc:
  file:
    - absent

/etc/publish-doc.yml:
  file:
    - absent

/etc/cron.hourly/publish-doc:
  file:
    - absent

/etc/nginx/conf.d/salt-doc.conf:
  file:
    - absent
