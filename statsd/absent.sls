{#
 Uninstall PyStatsD daemon, a statsd nodejs equivalent in python
 #}
statsd:
  file:
    - absent
    - name: /etc/init/statsd.conf
    - require:
      - service: statsd
  service:
    - dead
    - enable: False

/usr/local/statsd:
  file:
    - absent
    - require:
      - service: stastd
