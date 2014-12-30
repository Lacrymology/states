{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>

Install Denyhosts used to block SSH brute-force attack.
-#}
include:
  - apt
  - local
  - pysc
  - rsyslog

denyhosts-allowed:
  file:
    - managed
    - name: /var/lib/denyhosts/allowed-hosts
    - source: salt://denyhosts/allowed.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts

denyhosts:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - source: salt://denyhosts/config.jinja2
    - name: /etc/denyhosts.conf
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: denyhosts
      - pkg: denyhosts
      - file: denyhosts-allowed
    - require:
      - service: rsyslog
{#- PID file owned by root, no need to manage #}

/usr/local/bin/denyhosts-unblock:
  file:
    - managed
    - source: salt://denyhosts/denyhosts-unblock.py
    - user: root
    - group: root
    - mode: 500
    - require:
      - pkg: denyhosts
      - file: /usr/local
      - module: pysc

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
