{% for name in pillar['ssl'] %}
/etc/ssl/{{ name }}:
  file:
    - absent
{% endfor %}
