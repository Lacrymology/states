{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt_archive-nginx.cfg
{% endif %}

/etc/nagios/nrpe.d/salt_archive-nginx.cfg:
  file:
    - absent
