{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from "macros.jinja2" import salt_version with context %}
include:
  - apt
  - bash
  - salt
  - salt.master
  - pip
  - requests

{%- for type in ('profiles', 'providers') %}
/etc/salt/cloud.{{ type }}:
  file:
    - managed
    - template: jinja
    - mode: 440
    - source: salt://salt/cloud/{{ type }}.jinja2
    - require:
      - pkg: salt-cloud
{%- endfor %}

/etc/salt/cloud:
  file:
    - managed
    - template: jinja
    - mode: 440
    - source: salt://salt/cloud/config.jinja2
    - require:
      - pkg: salt-cloud

salt_cloud_remove_old_version:
  pip:
    - removed
    - name: salt-cloud
    - require:
      - module: pip

salt-cloud:
  pkg:
    - installed
    - skip_verify: True
    - require:
      - pkg: salt
      - pip: salt_cloud_remove_old_version
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/salt.cloud
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/cloud/requirements.jinja2
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/salt.cloud
    - watch:
      - file: salt-cloud
      - module: pip
      - pkg: salt-cloud
      - service: salt-master

salt-cloud-boostrap-script:
  file:
    - replace
    - name: /etc/salt/cloud.deploy.d/bootstrap-salt.sh
    - pattern: 'add-apt-repository -y ppa:saltstack/salt'
    - repl: echo "deb http://archive.robotinfra.com/mirror/salt/{{ salt_version() }}/ `lsb_release -c -s` main" > /etc/apt/sources.list.d/saltstack-salt-`lsb_release -c -s`.list && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0E27C0A6
    - mode: 500
    - user: root
    - group: root
    - template: jinja
    - require:
      - module: salt-cloud
      - file: bash

salt_cloud_digital_ocean_v2_module:
  file:
    - managed
    - source: salt://salt/cloud/digital_ocean_v2.py
    - name: /usr/lib/pymodules/python2.7/salt/cloud/clouds/digital_ocean_v2.py
    - require:
      - pkg: salt
      - pkg: salt-cloud
      - module: requests
