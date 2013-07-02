language-pack-en:
  pkg:
    - installed

{{ salt['pillar.get']('encoding', 'en_US.UTF-8') }}:
  locale:
    - system
    - require:
      - pkg: language-pack-en
