{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('salt.cloud') }}

/etc/sudoers.d/nrpe_salt_cloud:
  file:
    - absent

/usr/lib/nagios/plugins/check_saltcloud_images.py:
  file:
    - absent
