{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/etc/nagios/nrpe.d/jenkins-nginx.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('jenkins') }}
