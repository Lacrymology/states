{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- set hostnames = salt["pillar.get"]("syncthing:hostnames", [])|default(False, boolean=True) %}
include:
{%- if hostnames %}
  - nginx.diamond
{%- endif %}
  - rsyslog.diamond

syncthing_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[syncthing]]
        cmdline = ^\/usr\/bin\/syncthing -logflags=0 -home=\/var\/lib\/syncthing
