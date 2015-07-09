{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

strongswan:
  pkg:
    - installed
    - pkgs:
      - strongswan
{%- if grains['oscodename'] == 'trusty' %}
      - strongswan-plugin-eap-mschapv2
      - strongswan-plugin-xauth-generic
{%- endif %}
    - require:
      - cmd: apt_sources
