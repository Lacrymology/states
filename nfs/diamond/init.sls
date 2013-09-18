{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Diamond statistics for NFS
 -#}
include:
  - diamond

nfs_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nfs]]
        cmdline = nfs4d

/etc/diamond/collectors/NfsdCollector.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nfs/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/NfsdCollector.conf
