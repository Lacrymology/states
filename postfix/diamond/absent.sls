{#
 Turn off Diamond statistics for postfix
#}
{% if 'graphite_address' in pillar %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/PostfixCollector.conf
{% endif %}

/etc/diamond/collectors/PostfixCollector.conf:
  file:
    - absent