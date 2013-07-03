{#
 Diamond statistics for tomcat
#}

include:
  - diamond

tomcat_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[tomcat]]
        cmdline = .+java.+ org\.apache\.catalina\.startup\.Bootstrap start
