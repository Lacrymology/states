{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('diamond') }}

{%- for filename in ('/etc/diamond', '/usr/local/diamond') %}
{{ filename }}:
  file:
    - absent
    - require:
      - service: diamond
{%- endfor %}

diamond_clean_archive_logs:
  cmd:
    - run
    - name: rm -f {{ opts['cachedir'] }}/diamond.archive.log*
