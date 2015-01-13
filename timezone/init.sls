{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

#}
system_timezone:
  timezone:
    - system
    - name: {{ salt['pillar.get']('timezone', 'UTC') }}
