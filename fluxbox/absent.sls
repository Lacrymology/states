{#-
 Remove Fluxbox
#}

fluxbox:
  pkg:
    - purged
  file:
    - absent
    - name: ~/.fluxbox
