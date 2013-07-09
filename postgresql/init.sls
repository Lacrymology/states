include:
  - apt

postgresql-dev:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/postgresql/ {{ grains['lsb_codename'] }} main
{%- else %}
    - keyid: 8683D8A2
    - keyserver: keyserver.ubuntu.com
    - ppa: pitti/postgresql
    - name: deb http://ppa.launchpad.net/pitti/postgresql/ubuntu/ {{ grains['lsb_codename'] }} main
{%- endif %}
    - require:
      - pkg: python-apt
  pkg:
    - installed
    - name: libpq-dev
    - require:
      - pkgrepo: postgresql-dev
      - cmd: apt_sources
