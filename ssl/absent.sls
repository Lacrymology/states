{#
 Undo SSL state
 #}
{% for name in pillar['ssl']|default([]) %}
/etc/ssl/{{ name }}:
  file:
    - absent
{% endfor %}
