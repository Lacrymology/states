{{ opts['cachedir'] }}/salt-route53-requirements.txt:
  file:
    - absent

{% if salt['cmd.has_exec']('pip') %}
route53:
  pip:
    - removed
{% endif %}
