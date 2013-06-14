{#
 Diamond statistics for openldap
#}

include:
  - diamond

openldap_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[openldap]]
        exe = ^\/usr\/sbin\/slapd$
