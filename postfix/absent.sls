{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
postfix:
  pkg:
    - purged
    - pkgs:
      - postfix
      - postfix-ldap
  service:
    - dead
    - enable: False
    - require:
      - pkg: postfix

/var/mail/vhosts:
  file:
    - absent

{%- for file in ('postfix', 'aliases', 'aliases.db') %}
/etc/{{ file }}:
  file:
    - absent
    - require:
      - pkg: postfix
{%- endfor -%}
