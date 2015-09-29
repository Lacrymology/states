{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{% if salt['cmd.has_exec']('pip') %}
ddns_dnspython:
  pip:
    - removed
    - name: dnspython
    - reload_modules: True
{%- endif %}

ddns_tsig_key:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/ddns
