{#
 cleanup useless login prompt on virtual consoles
#}
ttys:
  service:
    - dead
    - names:
{% if grains['virtual'] == 'openvzve' %}
      - tty1
{% endif %}
    {% for number in [2, 3, 4, 5, 6] %}
      - tty{{ number }}
    {% endfor %}
