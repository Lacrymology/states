include:
  - apt

postgresql-dev:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/postgresql/ {{ grains['lsb_distrib_codename'] }} main
    - keyid: 8683D8A2
    - keyserver: keyserver.ubuntu.com
{%- else %}
    - ppa: pitti/postgresql
{%- endif %}
    - file: /etc/apt/sources.list.d/postgresql.list
    - require:
      - pkg: python-apt
      - pkg: python-software-properties
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - pkgrepo: postgresql-dev
      - cmd: apt_sources
