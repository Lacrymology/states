{{ salt['pillar.get']('locale', 'en_US.UTF-8') }}:
  locale:
    - system
