{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('graylog2.server.backup') }}
