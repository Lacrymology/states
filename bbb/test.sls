{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
{#- BBB don't work on != lucid -#}
{%- if grains['lsb_distrib_codename'] == 'lucid' %}
include:
  - bbb

test:
  nrpe:
    - run_all_checks
    - order: last
{%- endif -%}
