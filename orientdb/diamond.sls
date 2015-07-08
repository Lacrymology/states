include:
  - diamond
{#-
  - orientdb
#}

orientdb_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[orientdb]]
        cmdline = .+java.+com.orientechnologies.orient.server.OServerMain

{#-
extend:
  /etc/orientdb/config.xml:
    file:
      - context:
          debug: {{ salt['pillar.get']('orientdb:debug', False) }}
          profiler: True
#}
