{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt.nrpe
  - bash.nrpe
  - nrpe
  - pip.nrpe
  - requests.nrpe
  - salt.master.nrpe
  - salt.cloud
  - sudo.nrpe

{%- from 'nrpe/passive.jinja2' import passive_check, passive_absent with context %}
{%- if salt['pillar.get']('salt_cloud:providers', {}) %}
{{ passive_check('salt.cloud') }}
{%- else %}
{{ passive_absent('salt.cloud') }}
{%- endif %}

/etc/sudoers.d/nrpe_salt_cloud:
  file:
    - managed
    - template: jinja
    - source: salt://salt/cloud/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/lib/nagios/plugins/check_saltcloud_images.py:
  file:
    - managed
    - source: salt://salt/cloud/nrpe/check.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
      - file: /etc/sudoers.d/nrpe_salt_cloud
      - file: nsca-salt.cloud
      - file: salt_cloud_digital_ocean_v2_module
      - file: /etc/salt/cloud.profiles
      - file: /etc/salt/cloud.providers
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive
