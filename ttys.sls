{#- Usage of this is governed by a license that can be found in doc/license.rst

Cleanup useless login prompt on virtual consoles.
-#}

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
