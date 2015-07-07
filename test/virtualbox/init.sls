{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-

Use of this is governed by a license that can be found in doc/license.rst.

This file can only be applied on a VirtualBox VM that have test pillar set.
And it can't be executed trough ``integration.py``
-#}

{%- if grains['virtual'] == 'VirtualBox' and salt['pillar.get']('__test__', True) -%}
include:
  - kernel.modules
  - salt
    {%- if grains['kernelrelease'].endswith('-virtual') %}
  - virtualbox.guest
  - test.clean
    {%- endif %}

test-proxy-server:
  host:
    - present
    - ip: {{ salt['pillar.get']('test:proxy_server') }}
    - names:
      - apt.local
      - archive.local
    - watch_in:
      - module: apt

    {%- if not grains['kernelrelease'].endswith('-virtual') -%}
        {#- set root password #}
root:
  user:
    - present
    - password: {{ salt['password.encrypt_shadow'](salt['pillar.get']('test:root_password', 'pass')) }}

        {#- make sure no one log in those users anymore #}
        {%- for user in salt['group.info']('sudo')['members'] %}
root_only-{{ user }}:
  user:
    - present
    - name: {{ user }}
    - shell: /usr/sbin/nologin
    - require:
      - user: root
    - require_in:
      - module: linux-image-virtual
        {%- endfor %}

linux-image-virtual:
  pkg:
    - installed
  module:
    - run
    - name: system.reboot
    - require:
      - pkg: linux-image-virtual
      - pkg: linux-image-non-virtual
      - user: root

linux-image-non-virtual:
  pkg:
    - purged
    - pkgs:
        {%- for pkg in salt['pkg_installed.list_pkgs']() -%}
            {%- if (pkg.startswith('linux-image-') or pkg.startswith('linux-headers-')) and not pkg.startswith('-virtual') %}
      - {{ pkg }}
            {%- endif -%}
        {%- endfor %}
    - require:
      - pkg: linux-image-virtual
    {%- else -%}

        {%- for user in salt['group.info']('sudo')['members'] %}
root_only-{{ user }}:
  user:
    - absent
    - name: {{ user }}
    - purge: True
    - force: True
        {%- endfor %}

virtualbox-guest-utils:
  cmd:
    - wait
    - name: echo 'virtualbox-guest-utils hold' | dpkg --set-selections
    - watch:
      - pkg: virtualbox-guest

virtualbox-modules:
  cmd:
    - run
    - name: tar -cvf {{ opts['cachedir'] }}/vbox.tar /lib/modules/{{ grains['kernelrelease'] }}/updates/dkms/vbox*
    - require:
      - file: kernel_modules
  pkg:
    - purged
    - name: virtualbox-guest-dkms
    - pkgs:
      - virtualbox-guest-dkms
      - linux-headers-{{ grains['kernelrelease'] }}
    - require:
      - cmd: virtualbox-modules
  module:
    - wait
    - name: cmd.run
    - cmd: tar -xvf {{ opts['cachedir'] }}/vbox.tar
    - cwd: /
    - watch:
      - pkg: virtualbox-modules
  file:
    - absent
    - name: {{ opts['cachedir'] }}/vbox.tar
    - require:
      - module: virtualbox-modules

depmod:
  cmd:
    - wait
    - name: depmod -a
    - watch:
      - module: virtualbox-modules

/etc/udev/rules.d/70-persistent-net.rules:
  file:
    - absent

apt-get clean:
  cmd:
    - run
    - require:
      - file: virtualbox-modules

/etc/network/interfaces:
  file:
    - managed
    - user: root
    - group: root
    - template: jinja
    - source: salt://test/virtualbox/config.jinja2
    - require:
      - pkg: clean_pkg
{#- need salt 2014
eth0:
  network:
    - managed
    - enabled: False
    - type: eth
    - proto: none
    - ipaddr: 192.168.0.254
    - gateway: 192.168.0.1
    - netmask: 255.255.255.0
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - pkg: clean_pkg
#}

extend:
  clean_pkg:
    pkg:
      - order: last
      - require:
        - cmd: depmod
        - cmd: virtualbox-guest-utils
    {%- endif -%}
{%- endif -%}
