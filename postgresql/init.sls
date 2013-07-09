include:
  - apt

postgresql-dev:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb http://archive.bit-flippers.com/mirror/postgresql/ {{ grains['lsb_codename'] }} main
{%- else %}
    - keyid: 8683D8A2
    - keyserver: keyserver.ubuntu.com
    - ppa: pitti/postgresql
{%- endif %}
    - require:
      - pkg: python-apt
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - pkgrepo: postgresql-dev
      - cmd: apt_sources
