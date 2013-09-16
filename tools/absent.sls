basic:
  pkg:
    - purged
    - pkgs:
      - htop

{%- for i in 'iftop', 'iotop', 'nmap', 'tshark' %}
{{ i }}:
  pkg:
    - purged
{%- endfor %}
