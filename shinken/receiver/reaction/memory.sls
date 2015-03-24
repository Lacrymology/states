{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - shinken.receiver

shinken_restart_receiver:
  module:
    - run
    - name: service.restart
    - m_name: shinken-receiver
    - require:
      - service: shinken-receiver
