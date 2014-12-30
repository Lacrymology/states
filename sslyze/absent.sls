{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- set version = "0.9" -%}
{%- if grains['osarch'] == 'amd64' -%}
    {%- set bits = "64" -%}
{%- else -%}
    {%- set bits = "32" -%}
{%- endif -%}
{% for file in ('/usr/local/src/sslyze-' + version|replace(".", "_") + '-linux' + bits, '/usr/lib/nagios/plugins/check_ssl_configuration.py', '/usr/local/nagios/salt-sslyze-requirements.txt') %}
{{ file }}:
  file:
    - absent
{% endfor %}
