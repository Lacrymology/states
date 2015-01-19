{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - rsyslog
  - xinetd

rsync:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - dead
    - enable: False
    - require:
      - pkg: rsync
  file:
    - absent
    - name: /etc/init.d/rsync
    - require:
      - service: rsync

/etc/xinetd.d/rsync:
  file:
    - managed
    - source: salt://rsync/xinetd.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - context:
        per_source: {{ salt['pillar.get']('rsync:limit_per_ip', '"UNLIMITED"') }}
    - require:
      - file: /etc/xinetd.d
      - file: rsync
    - watch_in:
      - service: xinetd

/etc/rsyncd.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://rsync/config.jinja2
    - require:
      - pkg: rsync
      - file: rsync
    - watch_in:
      - service: xinetd
