{{ opts['cachedir'] }}/salt-virtualenv-requirements.txt:
  file:
      - absent
{#

{% if salt['cmd.has_exec']('pip') %}
virtualenv:
  pip:
    - removed
{% endif %}
#}
