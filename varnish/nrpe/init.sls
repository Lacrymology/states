{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - bash.nrpe
  - nrpe

{{ passive_check('varnish') }}
