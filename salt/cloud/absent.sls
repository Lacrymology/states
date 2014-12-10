{#-
Copyright (c) 2013, Hung Nguyen Viet

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
