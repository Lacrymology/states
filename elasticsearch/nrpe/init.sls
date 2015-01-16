{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- set formula = 'elasticsearch' -%}
{%- set ssl = salt['pillar.get'](formula + ':ssl', False) -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - bash.nrpe
  - cron.nrpe
  - elasticsearch.nrpe.instance
  - nrpe
  - tmpreaper.nrpe
{%- if ssl %}
  - ssl.nrpe
  - nginx.nrpe
{%- endif %}

{{ passive_check(formula) }}

extend:
  /usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
    file:
      - require:
        - file: nsca-{{ formula }}
