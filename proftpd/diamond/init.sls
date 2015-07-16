{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
{#- Take a look at /diamond/doc/fail2ban.rst for more details -#}
{%- if salt['pillar.get']('fail2ban:banaction', 'hostsdeny').startswith('iptables') %}
  - firewall
{%- endif %}
  - postgresql.server.diamond
  - rsyslog.diamond

proftpd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[proftpd]]
        exe = ^\/usr\/sbin\/proftpd$

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip with context %}
{{ fail2ban_count_ip('proftpd') }}
