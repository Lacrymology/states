{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- set ssl = salt['pillar.get']('ldap:ssl', False) %}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('openldap') }}
