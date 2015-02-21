{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - diamond
  - diamond.nrpe

test_diamond_config:
  cmd:
    - run
    {#- if it outputs "Failed", config is wrong, diamond does not die / return fail
    for that, so this test is needed #}
    - name: '! /usr/local/diamond/bin/diamond --run processresources --foreground --log-stdout | grep Failed'
    - require:
      - sls: diamond

test:
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - require:
      - sls: diamond
      - sls: diamond.nrpe
    - map:
        ProcessResources:
          {{ diamond_process_test('diamond') }}
          {{ diamond_process_test('init') }}
          {{ diamond_process_test('udev') }}
        CPU:
          cpu.total.user: True
          cpu.total.nice: True
          cpu.total.system: True
          cpu.total.idle: True
          cpu.total.iowait: True
        DiskSpace:
          diskspace.root.byte_free: True
{%- if grains['virtual'] != 'openvzve' %}
        DiskUsage:
          iostat.(md[0-9]*|[vs]d[a-z][0-9]*|xvd[a-z][0-9]*|dm\-[0-9]*).iops: True
{%- endif %}
        Filestat:
          files.max: True
        Interrupt:
          interrupts.ERR: True
        LoadAverage:
          loadavg.01: True
        Memory:
          memory.MemFree: True
        Network:
          network.lo.rx_byte: True
          network.lo.tx_byte: True
{%- set ping = salt['pillar.get']('diamond:ping', {}) %}
{%- if ping %}
        {%- set first_host = ping|first %}
        Ping:
          ping.{{ salt['pillar.get']('diamond:ping:' ~ first_host)|replace('.', '_') }}: True
{%- endif %}
        ProcessStat:
          proc.procs_running: True
        Sockstat:
          sockets.tcp_tw: True
        TCP:
          tcp.CurrEstab: True
        Uptime:
          uptime.minutes: True
        VMStat:
          vmstat.pgpgin: True
