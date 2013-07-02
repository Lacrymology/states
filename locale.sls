{#
Set the locale for machine
#}
{{ salt['pillar.get']('encoding', 'en_US.UTF-8') }}:
  locale:
    - system
