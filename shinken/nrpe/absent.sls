{#
 Remove Nagios NRPE check for Shinken
#}
{% set roles = ('broker', 'arbiter', 'reactionner', 'poller', 'scheduler') %}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/shinken-nginx.cfg
{% for role in roles %}
        - file: /etc/nagios/nrpe.d/shinken-{{ role }}.cfg
{% endfor %}
{% endif %}

/etc/nagios/nrpe.d/shinken-nginx.cfg:
  file:
    - absent

{% for role in roles %}
/etc/nagios/nrpe.d/shinken-{{ role }}.cfg:
  file:
    - absent
{% endfor %}
