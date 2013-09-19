{#
 Diamond statistics for NTP
#}
include:
  - diamond
  - rsyslog.diamond
  - ntp

ntp_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[ntp]]
        exe = ^\/usr\/sbin\/ntpd$

diamond_ntp:
  file:
    - managed
    - name: /etc/diamond/collectors/NtpdCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/basic_collector.jinja2
    - require:
      - file: /etc/diamond/collectors

extend:
  diamond:
    service:
      - require:
        - service: ntp
      - watch:
        - file: diamond_ntp
