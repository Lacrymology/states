{#
 Turn off Diamond statistics for NFS
 #}
{% if 'graphite_address' in pillar %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/NfsdCollector.conf
{% endif %}

/etc/diamond/collectors/NfsdCollector.conf:
  file:
    - absent
