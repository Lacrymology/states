{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.absent
  - backup.client.absent

s3lite:
  file:
    - absent
    - name: /usr/local/s3lite

/etc/s3lite.yml:
  file:
    - absent

/usr/local/bin/s3lite:
  file:
    - absent
