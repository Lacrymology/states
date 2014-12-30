{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - rsyslog

{% if salt['pillar.get']('ntp:servers', []) | length > 0 %}
ntpdate:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/default/ntpdate
    - template: jinja
    - source: salt://ntp/ntpdate.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ntpdate
{% endif %}

ntp:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: ntp
  file:
    - managed
    - name: /etc/ntp.conf
    - template: jinja
    - source: salt://ntp/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ntp
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - pkg: ntp
      - service: rsyslog
    - watch:
      - file: ntp
      - user: ntp
{#- PID file owned by root, no need to manage #}
