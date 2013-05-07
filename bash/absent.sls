{#
 Remove bash customisation
 #}
/etc/profile.d/bash_prompt.sh:
  file:
    - absent

/root/.bashrc:
  file:
    - comment
    - regex: ^source \/etc\/profile\.d\/bash_prompt\.sh
