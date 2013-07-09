include:
  - apt

postgresql-dev:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/postgresql/ {{ grains['lsb_codename'] }} main
{%- else %}
    - ppa: pitti/postgresql
{%- endif %}
    - require:
      - pkg: python-apt
      - pkg: python-software-properties
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - pkgrepo: postgresql-dev
      - cmd: apt_sources
