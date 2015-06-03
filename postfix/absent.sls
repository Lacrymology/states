{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

postfix:
  pkg:
    - purged
    - pkgs:
      - postfix
      - postfix-ldap
      - postfix-pcre
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
