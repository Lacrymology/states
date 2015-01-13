{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Remove bash customization.
-#}
/etc/profile.d/bash_prompt.sh:
  file:
    - absent

/usr/local/share/salt_common.sh:
  file:
    - absent
