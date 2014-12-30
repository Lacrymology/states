{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
slapd:
  pkg:
    - purged
    - pkgs:
      - slapd
      - ldap-utils
    - require:
      - service: slapd
  service:
    - dead
  file:
    - absent
    - name: /etc/ldap
    - require:
      - pkg: slapd

/var/lib/ldap:
  file:
    - absent
    - require:
      - pkg: slapd

openldap:
  user:
    - absent
    - require:
      - pkg: slapd

{{ opts['cachedir'] }}/dbconfig.ldif:
  file:
    - absent

{{ opts['cachedir'] }}/usertree.ldif:
  file:
    - absent
