{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - diamond
  - diamond.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - map:
        ProcessResources:
          process.diamond.memory_percent: True
          process.init.num_threads: False
          process.udev.num_threads: False
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
{%- if salt['pillar.get']('diamond:ping', {}) %}
        {%- set first_host = salt['pillar.get']('diamond:ping', {})|first %}
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
