{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
