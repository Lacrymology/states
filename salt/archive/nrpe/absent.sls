{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/nagios/nrpe.d/salt_archive-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/salt-archive.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('salt.archive') }}

/etc/sudoers.d/salt_archive_nrpe:
  file:
    - absent
