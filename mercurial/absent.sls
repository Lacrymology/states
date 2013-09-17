{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
mercurial:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/salt-mercurial-requirements.txt
{%- if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{%- endif %}
