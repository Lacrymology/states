{#
 Remove Nagios NRPE check for NFS
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/nfs.cfg
{% endif %}

/etc/nagios/nrpe.d/nfs.cfg:
  file:
    - absent
