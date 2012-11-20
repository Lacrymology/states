{# tty are useless in most cases #}
{% for action in ['dead', 'disabled'] %}
{{ action }}_ttys:
  service:
    - {{ action }}
    - names:
{% if grains['virtual'] == 'openvzve' %}
      - tty1
{% endif %}
    {% for number in [2, 3, 4, 5, 6] %}
      - tty{{ number }}
    {% endfor %}
{% endfor %}
