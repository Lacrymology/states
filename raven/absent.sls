{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
raven:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/salt-raven-requirements.txt
{% if salt['cmd.has_exec']('pip') %}
  pip:
    - name: raven
    - removed
    - order: 1
{% endif %}
