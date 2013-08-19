/etc/apt/sources.list.d/mariadb.list:
  file:
    - absent

mariadb_remove_key:
  cmd:
    - run
    - name: 'apt-key del 0xcbcb082a1bb943db'
    - onlyif: apt-key list | grep -q 0xcbcb082a1bb943db

mariadb:
  pkgrepo:
    - absent
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/mariadb/5.5.31 {{ grains['lsb_codename'] }} main
{%- else %}
    - name: deb http://repo.maxindo.net.id/mariadb/repo/5.5/ubuntu precise main
{%- endif %}
