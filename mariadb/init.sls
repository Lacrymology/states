{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

{#-

Creating mariadb mirror:

    export MDB_VERSION=5.5.41 # set version to mirror here
    mkdir mariadb_mirror mariadb_essential
    rsync -av rsync.osuosl.org::mariadb/mariadb-${MDB_VERSION}/repo/ubuntu/ mariadb_mirror
    # see another sources here: https://mariadb.com/kb/en/mariadb/download/mirroring-mariadb/

    cp -R mariadb_mirror/{dists,pool}  mariadb_essential
    cd mariadb_essential
    find . -type f -name 'index.*' -delete
    find pool/ -type f ! -name '*.deb' -delete

    #To keep only precise and trusty:

    find dists/ -maxdepth 1 -mindepth 1 ! \( -name precise -or -name trusty \) | xargs rm -r
    find pool/ \( -type f -name '*.deb' ! \( -name '*precise*' -or -name '*trusty*' \) \) -delete
#}

mariadb:
  pkgrepo:
    - managed
    - key_url: salt://mariadb/key.gpg
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/mariadb/5.5.41 {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://mariadb.biz.net.id//repo/5.5/ubuntu precise main
{%- endif %}
    - file: /etc/apt/sources.list.d/mariadb.list
    - clean_file: True
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - name: libmysqlclient18
    - require:
      - pkgrepo: mariadb
      - pkg: mysql-common

mysql-common:
  pkg:
    - installed
    - require:
      - pkgrepo: mariadb
