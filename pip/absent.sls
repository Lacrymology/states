{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{% set version='1.5.2' %}

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/pip-{{ version }}:
  file:
    - absent

{{ opts['cachedir'] }}/pip:
  file:
    - absent

{#
 Only during integration test, we don't want to wipe PIP cache for future usage.
 #}
{% if not salt['pillar.get']('__test__', False) %}
/var/cache/pip:
  file:
    - absent
{% endif %}

{{ salt['user.info']('root')['home'] }}/.pip:
  file:
    - absent

{#
  Can't uninstall the following as they're used elsewhere
python-setuptools:
  pkg:
    - purged
#}
