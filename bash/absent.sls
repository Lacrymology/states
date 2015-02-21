{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/profile.d/bash_prompt.sh:
  file:
    - absent

/usr/local/share/salt_common.sh:
  file:
    - absent
