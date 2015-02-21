{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/diamond/collectors/AmavisCollector.conf:
  file:
    - absent
    {#- specified a small order, try to make this run before amavis.absent run,
        otherwise, amavis collector will notify error due to not found amavis-agent #}
    - order: 10
