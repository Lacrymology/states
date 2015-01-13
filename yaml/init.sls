{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

et ma-#}
include:
  - apt

yaml:
  pkg:
    - installed
    - name: libyaml-dev
    - require:
      - cmd: apt_sources
