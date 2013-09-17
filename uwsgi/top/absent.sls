{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall uWSGI top
 -#}

{#
{% if salt['cmd.has_exec']('pip') %}
uwsgitop:
  pip:
    - removed
{% endif %}
#}
