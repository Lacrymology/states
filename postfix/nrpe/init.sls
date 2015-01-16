{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
{%- if salt['pillar.get']('postfix:spam_filter', False) %}
  - amavis.nrpe
    {%- if salt['pillar.get']('amavis:check_virus', True) %}
  - clamav.nrpe
    {%- endif %}
{%- endif %}
  - apt.nrpe
  - nrpe
{% if salt['pillar.get']('postfix:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('postfix') }}
