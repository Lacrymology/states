{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set is_test = salt['pillar.get']('__test__', False) %}

/etc/.java:
  file:
    - absent

{#-
when uninstall ca-certificates will run update-ca-certificates and
fail if /etc/ssl/certs doesn't exist.
remove the trigger here to workaround the problem.
#}
{%- if is_test %}
/var/lib/dpkg/info/ca-certificates-java.triggers:
  file:
    - absent
{%- endif %}
