{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/usr/local/salt-common-doc:
  file:
    - absent

/etc/doc-publish.yml:
  file:
    - absent

/etc/cron.hourly/doc-publish:
  file:
    - absent

/etc/nginx/conf.d/salt-doc.conf:
  file:
    - absent

/usr/local/bin/build-salt-common-doc.py:
  file:
    - absent

/usr/local/salt-common-doc-source:
  file:
    - absent
