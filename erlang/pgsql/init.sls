{% set build_dir = '/usr/lib/erlang/lib' %}

include:
  - erlang

erlang_mod_pgsql:
  archive:
    - extracted
    - name: {{ build_dir }}
    - source: https://github.com/lamoanh/pgsql/archive/v1.0.tar.gz 
    - source_hash: md5=757dbadf64257426fbc2e3127075e9a6
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ build_dir }}/pgsql-1.0
    - require:
      - pkg: erlang
  cmd:
    - run
    - name: ./build.sh
    - cwd: /{{ build_dir }}/pgsql-1.0 {# cwd here because build.sh use relative path #}
    - user: root
    - unless: test -f {{ build_dir }}/pgsql-1.0/ebin/pgsql.beam
    - require:
      - archive: erlang_mod_pgsql

