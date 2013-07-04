{#
Set the locale for machine
#}
system_locale:
  locale:
    - system
    - name: {{ salt['pillar.get']('encoding', 'en_US.UTF-8') }}
