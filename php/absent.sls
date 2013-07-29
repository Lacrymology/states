php:
  file:
    - absent
    - name: /etc/apt/sources.list.d/lucid-php5.list
  pkg:
    - purged
    - name: php5
  cmd:
    - run
    - name: 'apt-key del 67E15F46'
    - onlyif: apt-key list | grep -q 67E15F46
