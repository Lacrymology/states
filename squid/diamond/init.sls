{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}

include:
  - diamond
  - squid

squid_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[squid]]
        cmdline = ^\/usr\/sbin\/squid3,^\(unlinkd\)$

squid_diamond_SquidCollector:
  file:
    - managed
    - name: /etc/diamond/collectors/SquidCollector.conf
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://squid/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
      - service: squid
    - watch_in:
      - service: diamond
