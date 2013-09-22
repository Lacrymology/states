{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Diamond
=======

Install diamond, a daemon and toolset for gather system statistics
and publishing them to graphite.

Mostly operating system related such as CPU, memory.

but it's often plug with third party daemon such as PostgreSQL to gather
those stats as well.
Each of those other daemons state come with their own configuration file
that are put in /etc/diamond/collectors, directory check at startup for
additional configurations.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.
graphite_address: IP/Hostname of carbon/graphite server.

Optional Pillar
---------------

diamond:
  interfaces:
    - eth0
    - lo
  ping:
    - 192.168.1.1
    - 192.168.1.2
shinken_pollers:
  - 192.168.1.1
graylog2_address: 192.168.1.1

diamond:interfaces: list of network interface check for I/O stats.
    default show in example.
diamond:ping: list of IP/hostname ping to monitor latency and availability.
graylog2_address: IP/Hostname of centralized Graylog2 server
shinken_pollers: IP address of monitoring poller that check this server.
-#}
{#- TODO: sentry/raven integration -#}
include:
  - git
  - python.dev
  - local
  - virtualenv
  - rsyslog
  - rsyslog.diamond
{% if 'shinken_pollers' in pillar %}
  - diamond.nrpe
{% endif %}

/etc/diamond:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

/etc/diamond/collectors:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - file: /etc/diamond

diamond_upstart:
  file:
    - managed
    - name: /etc/init/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/upstart.jinja2
    - require:
      - module: diamond

diamond_requirements:
  file:
    - managed
    - name: /usr/local/diamond/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/requirements.jinja2
    - require:
      - virtualenv: diamond

/etc/diamond/collectors/ProcessMemoryCollector.conf:
  file:
    - absent

diamond:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/diamond
    - require:
      - module: virtualenv
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-requirements.txt
    - require:
      - pkg: git
      - virtualenv: diamond
    - watch:
      - pkg: python-dev
      - file: diamond_requirements
  file:
    - managed
    - name: /etc/diamond/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/config.jinja2
    - require:
      - file: /etc/diamond
{%- for host in salt['pillar.get']('diamond:ping', []) -%}
    {%- if loop.first %}
    - context:
      ping_hosts:
    {%- endif %}
        {{ host }}: {{ pillar['diamond']['ping'][host] }}
{%- endfor %}
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
    - watch:
      - virtualenv: diamond
      - file: diamond
      - file: diamond_upstart
      - module: diamond
      - cmd: diamond
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
  cmd:
    - wait
    - name: find /usr/local/diamond -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: diamond

/etc/diamond/collectors/ProcessResourcesCollector.conf:
  file:
    - managed
    - template: jinja
    - source: salt://diamond/ProcessResourcesCollector.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/diamond/collectors
      - file: /etc/diamond/collectors/ProcessMemoryCollector.conf
