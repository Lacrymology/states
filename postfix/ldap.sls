{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - postfix

postfix-ldap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: postfix
    - require_in:
      - service: postfix
