{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

squid_diamond_use_publish_not_derivative:
  file:
    - replace
    - name: /usr/local/diamond/share/diamond/collectors/squid/squid.py
    - pattern: self.publish_counter
    - repl: self.publish
    - require:
      - module: diamond
    - watch_in:
      - service: diamond
