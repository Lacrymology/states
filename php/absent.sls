php:
  file:
    - absent
    - name: /etc/apt/sources.list.d/lucid-php5.list
  pkg:
    - purged
    - name: php5
