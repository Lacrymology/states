{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - nginx.diamond
  - nodejs.diamond
  - postgresql.server.diamond
  - rsyslog.diamond

etherpad_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[etherpad]]
        cmdline = ^node node_modules\/ep_etherpad\-lite\/node\/server\.js$
