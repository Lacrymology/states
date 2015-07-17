{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('strongswan') }}

extend:
  strongswan:
    pkg:
      - purged
      - pkgs:
        - strongswan
        - strongswan-plugin-eap-mschapv2
        - strongswan-plugin-xauth-generic
      - require:
        - service: strongswan
    file:
      - absent
      - names:
        - /etc/ipsec.d
        - /etc/ipsec.conf
        - /etc/ipsec.secrets
        - /var/lib/strongswan
      - require:
        - pkg: strongswan-ike

strongswan-ike:
  pkg:
    - purged
{%- if grains['oscodename'] == 'precise' %}
    - pkgs:
      - strongswan-ikev1
      - strongswan-ikev2
{%- endif %}
    - require:
      - pkg: strongswan
