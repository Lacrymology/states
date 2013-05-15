include:
  - reprepro.nrpe
  - nginx.nrpe
{% if pillar['salt_ppa_mirror']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
