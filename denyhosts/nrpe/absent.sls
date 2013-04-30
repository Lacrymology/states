{#
 Remove Nagios NRPE check for Denyhosts
#}
include:
  - denyhosts
{% if 'shinken_pollers' in pillar %}
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/denyhosts.cfg
{% endif %}
  denyhosts:
    service:
      - watch:
        - file: /var/lib/denyhosts/allowed-hosts

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - absent

/var/lib/denyhosts/allowed-hosts:
  file:
    - absent
