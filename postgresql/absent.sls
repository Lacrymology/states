{#
 Undo postgresql state
#}
/etc/apt/sources.list.d/pitti-postgresql-precise.list:
  file:
    - absent

apt-key del 8683D8A2:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 8683D8A2

postgresql-dev:
  pkg:
    - purged
    - name: libpq-dev
  pkgrepo:
    - absent
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/postgresql/ {{ grains['lsb_codename'] }} main
{%- else %}
    - ppa: pitti/postgresql
{%- endif %}
