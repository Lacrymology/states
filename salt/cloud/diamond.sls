{#
 Diamond statistics for salt_cloud
#}

include:
  - diamond

salt_cloud_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt-cloud]]
        exe = ^python \/usr\/bin\/salt-cloud
