{#
 Remove Nagios NRPE check for Denyhosts
#}
include:
  - denyhosts
{% if 'shinken_pollers' in pillar %}
  - nrpe
{% endif %}

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - absent

/var/lib/denyhosts/allowed-hosts:
  file:
    - absent

extend:
  denyhosts:
    service:
      - watch:
        - file: /var/lib/denyhosts/allowed-hosts
{% if 'shinken_pollers' in pillar %}
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/denyhosts.cfg
{% endif %}
