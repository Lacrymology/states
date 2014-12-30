{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('postfix_stats') }}

postfix_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/PostfixCollector.conf

postfix_diamond_queue_length:
  file:
    - absent
    - name: /usr/local/diamond/share/diamond/user_scripts/postfix_queue_length.sh

/etc/rsyslog.d/postfix_stats.conf:
  file:
    - absent

/usr/local/diamond/bin/postfix_rsyslog.py:
  file:
    - absent

postfix_stats-requirements:
  file:
    - absent
    - name: /usr/local/diamond/salt-postfix-requirements.txt

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/diamond/postfix-requirements.txt:
  file:
    - absent
