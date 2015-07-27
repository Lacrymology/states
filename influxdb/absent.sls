influxdb:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: influxdb

{{ opts["cachedir"] }}/pip/influxdb:
  file:
    - absent
