{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - shinken.scheduler

shinken_restart_scheduler:
  module:
    - run
    - name: service.restart
    - m_name: shinken-scheduler
    - require:
      - service: shinken-scheduler
