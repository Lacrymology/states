{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

erlang:
  pkg:
    - latest
    - name: erlang-nox
    - require:
      - cmd: apt_sources
