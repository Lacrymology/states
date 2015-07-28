influxdb:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: influxdb
  user:
    - absent
    - require:
      - pkg: influxdb
  group:
    - absent
    - require:
      - pkg: influxdb

{{ opts["cachedir"] }}/pip/influxdb:
  file:
    - absent

{%- for file in (
  "/etc/rc0.d/K20influxdb",
  "/etc/rc2.d/S20influxdb",
  "/etc/init.d/influxdb",
  "/etc/rc1.d/K20influxdb",
  "/etc/rc4.d/S20influxdb",
  "/etc/rc6.d/K20influxdb",
  "/etc/rc3.d/S20influxdb",
  "/etc/rc5.d/S20influxdb",
  "/var/log/influxdb/",
  "/var/lib/influxdb/",
  "/etc/influxdb",
)%}
{{ file }}:
  file:
    - absent
    - require:
      - pkg: influxdb
{%- endfor %}
