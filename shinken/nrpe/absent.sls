{#
 Remove Nagios NRPE check for Shinken
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

{% if grains['id'] in pillar['shinken']['architecture']['broker'] %}
/etc/nagios/nrpe.d/shinken-nginx.cfg:
  file:
    - absent
{% endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
{% for role in pillar['shinken']['architecture'] %}
{% if grains['id'] in pillar['shinken']['architecture'][role] %}
        - file: /etc/nagios/nrpe.d/shinken-{{ role }}.cfg
{% endif %}
{% endfor %}
{% if grains['id'] in pillar['shinken']['architecture']['broker'] %}
        - file: /etc/nagios/nrpe.d/shinken-nginx.cfg
{% endif %}
{% endif %}
{% endif %}

{% for role in pillar['shinken']['architecture'] %}
{% if grains['id'] in pillar['shinken']['architecture'][role] %}
/etc/nagios/nrpe.d/shinken-{{ role }}.cfg:
  file:
    - absent
{% endif %}
{% endfor %}
