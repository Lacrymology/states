{#
 Diamond statistics for clamav
#}

include:
  - diamond

clamav_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[clamav]]
        exe = ^\/usr\/sbin\/clamd$
        [[freshclam]]
        exe = ^\/usr\/bin\/freshclam$
