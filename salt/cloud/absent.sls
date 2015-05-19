{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - name: {{ grains['saltpath'] }}/cloud/clouds/digital_ocean_v2.py

salt_cloud_digital_ocean_v2_module_pyc:
  file:
    - absent
    - name: {{ grains['saltpath'] }}/cloud/clouds/digital_ocean_v2.pyc
