{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - fail2ban.diamond
{#- Take a look at /diamond/doc/fail2ban.rst for more details -#}
{%- if salt['pillar.get']('fail2ban:banaction', 'hostsdeny').startswith('iptables') %}
  - firewall
{%- endif %}
  - xinetd.diamond

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip with context %}
{{ fail2ban_count_ip('xinetd-fail') }}
