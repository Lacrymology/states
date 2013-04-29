{#
 Remove Nagios NRPE check for Memcache
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/memcache.cfg
{% endif %}

/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - absent
