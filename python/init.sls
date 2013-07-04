include:
  - apt

/etc/python:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755

python:
  pkg:
    - latest
    - name: python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}
    - require:
      - cmd: apt_sources
