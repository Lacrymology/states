{#
 Remove bash customisation
 #}
/etc/profile.d/bash_prompt.sh:
  file:
    - absent
