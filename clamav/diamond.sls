{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - cron.diamond
  - diamond
  - rsyslog.diamond


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
