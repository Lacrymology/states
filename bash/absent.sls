{#
 Remove bash customisation
 #}
/etc/profile.d/bash_prompt.sh
  file:
    - absent

/root/.bashrc:
  file:
    - comment
    - text: source /etc/profile.d/bash_prompt.sh
