{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- for type in ('profiles', 'providers', 'profiles.d', 'providers.d', 'deploy.d') %}
/etc/salt/cloud.{{ type }}:
  file:
    - absent
    - require:
      - pkg: salt-cloud
{%- endfor %}

/etc/salt/cloud:
  file:
    - absent
    - require:
      - pkg: salt-cloud

salt-cloud:
  pkg:
    - purged
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/salt.cloud

python-libcloud:
  pkg:
    - purged

salt_cloud_digital_ocean_v2_module:
  file:
    - absent
    - name: /usr/lib/pymodules/python2.7/salt/cloud/clouds/digital_ocean_v2.py

salt_cloud_digital_ocean_v2_module_pyc:
  file:
    - absent
    - name: /usr/lib/pymodules/python2.7/salt/cloud/clouds/digital_ocean_v2.pyc
