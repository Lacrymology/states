{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
dovecot-agent:
  user:
    - absent
  file:
    - absent
    - name: /home/dovecot-agent
    - require:
      - user: dovecot-agent
