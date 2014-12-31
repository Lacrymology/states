{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
include:
  - doc
  - tmpreaper
  - tmpreaper.diamond
  - tmpreaper.nrpe

{%- call test_cron() %}
- sls: tmpreaper
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
