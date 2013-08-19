basic:
  pkg:
    - purged
    - names:
      - htop

{%- for i in 'iftop', 'iotop', 'nmap', 'tshark' %}
{{ i }}:
  pkg:
    - purged
{%- endfor %}
