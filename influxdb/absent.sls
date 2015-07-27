influxdb:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: influxdb

/var/lib/influxdb:
  file:
    - absent
    - require:
      - pkg: influxdb

{{ opts["cachedir"] }}/pip/influxdb:
  file:
    - absent

/etc/influxdb:
  file:
    - absent
