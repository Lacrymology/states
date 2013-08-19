route53:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/salt-route53-requirements.txt
{%- if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{%- endif %}
