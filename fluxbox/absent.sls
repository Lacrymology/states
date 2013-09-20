{#-
 Remove Fluxbox
#}
{%- set root_home = salt['user.info']('root')['home'] %}

fluxbox:
  pkg:
    - purged
  file:
    - absent
    - name: {{ root_home }}/.fluxbox
