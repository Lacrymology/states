include:
  - diamond
  - nginx.diamond
  - postgresql.server.diamond

ejabberd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[ejabberd]]
        exe = ^\/usr\/lib\/erlang\/erts-.+\/bin\/beam.+ejabberd.+$,^\/usr\/lib\/erlang\/erts-.+\/bin\/epmd$
