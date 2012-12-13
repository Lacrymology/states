{# tty are useless in most cases #}
ttys:
  service:
    - dead
    - enable: False
    - names:
{% if grains['virtual'] == 'openvzve' %}
      - tty1
{% endif %}
    {% for number in [2, 3, 4, 5, 6] %}
      - tty{{ number }}
    {% endfor %}
{% endfor %}
