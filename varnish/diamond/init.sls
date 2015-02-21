{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - rsyslog.diamond
  - varnish

varnish_diamond_ProcessResourcesCollector:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[varnish]]
        exe = ^\/usr\/sbin\/varnishd$

varnish_diamond_VarnishCollector:
  file:
    - managed
    - name: /etc/diamond/collectors/VarnishCollector.conf
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://varnish/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
    - watch_in:
      - service: diamond

extend:
  diamond:
    service:
      - require:
        - service: varnish
