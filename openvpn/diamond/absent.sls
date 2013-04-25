{#
 Turn off Diamond statistics for OpenVPN
#}
{% if 'graphite_address' in pillars %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/OpenVPNCollector.conf
{% endif %}

/etc/diamond/collectors/OpenVPNCollector.conf:
  file:
    - absent
