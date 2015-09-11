{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}

/etc/sudoers.d/check_dhcp:
  file:
    - absent

{{ passive_absent("dhcp.client") }}
