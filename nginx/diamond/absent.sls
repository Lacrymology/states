{#
 Remove Diamond statistics for Nginx
#}
{% if 'graphite_address' in pillar %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/NginxCollector.conf
{% endif %}

/etc/diamond/collectors/NginxCollector.conf:
  file:
    - absent
