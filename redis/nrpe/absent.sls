{#
 Remove Nagios NRPE check for redis
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/redis.cfg
{% endif %}

/etc/nagios/nrpe.d/redis.cfg:
  file:
    - absent
