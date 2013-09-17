{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - reprepro.nrpe
  - nginx.nrpe
{% if pillar['salt_ppa_mirror']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}

{# TODO: add check to make sure that the copy is there #}
