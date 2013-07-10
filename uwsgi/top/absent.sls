{#
 Uninstall uWSGI top
 #}

{#
{% if salt['cmd.has_exec']('pip') %}
uwsgitop:
  pip:
    - removed
{% endif %}
#}
