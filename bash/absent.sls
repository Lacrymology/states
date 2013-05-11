{#
 Remove bash customisation
 #}
/etc/profile.d/bash_prompt.sh:
  file:
    - absent

{{ salt['user.info']('root')['home'] }}/.bashrc:
  file:
    - comment
    - regex: ^source.*bash_prompt.*
