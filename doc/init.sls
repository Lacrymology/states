{#-
 Build salt-common (and non-common) documentation in salt minion cache
 directory.
 This is mainly used as source of data to perform tests on pillars and metrics.

 To manually rebuild doc perform the following::

   source /var/cache/salt/minion/doc/bin/activate

 And go where the source code is, it might be in:
 ``/var/cache/salt/minion/files/$YOUR_ENV``

 or in ``/root/salt/states``

 maybe in ``/media/sf_salt`` somewhere.

 And run::

   doc/build.py /var/cache/salt/minion/doc/output
 -#}
include:
  - locale
  - pip
  - virtualenv

doc_root:
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/doc/requirements.txt
    - watch:
      - file: doc
      {#- as doc/requirements.txt don't get erased on every *.absent pass,
         run module every possible time. #}
      - file: pip
      - module: pip
      - archive: pip

{{ opts['cachedir'] }}/doc/output:
  file:
    - directory
    - require:
      - virtualenv: doc

doc:
  virtualenv:
    - manage
    - name: {{ opts['cachedir'] }}/doc
    - system_site_packages: True
    - require:
      - module: virtualenv
  file:
    - managed
    - name: {{ opts['cachedir'] }}/doc/requirements.txt
    - source: salt://doc/requirements.txt
    - user: root
    - group: root
    - mode: 440
    - require:
      - virtualenv: doc
  module:
    - wait
    - name: pip.install
    - bin_env: {{ opts['cachedir'] }}/doc
    - requirements: {{ opts['cachedir'] }}/doc/requirements.txt
    - require:
      - virtualenv: doc
    - watch:
      - file: doc
  cmd:
    - wait
    - name: {{ opts['cachedir'] }}/doc/bin/python doc/build.py {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: system_locale
    - watch:
      - virtualenv: doc
      - module: doc
      - file: {{ opts['cachedir'] }}/doc/output
      {#- not required but shortcut for doc consumer #}
      - module: doc_root
    - env:
      - VIRTUAL_ENV: {{ opts['cachedir'] }}/doc
{#- if in local file client mode, cp.cache_master module is useless, just run
    from the first files_root defined. #}
{%- if opts['file_client'] == 'local' %}
    - cwd: {{ opts['file_roots'][opts['file_roots'].keys()[0]][0] }}
{%- else -%}
    {%- set saltenv = salt['common.saltenv']() %}
    - cwd: {{ opts['cachedir'] }}/files/{{ saltenv }}

doc_sync_files:
  module:
    - wait
    - name: cp.cache_master
    - saltenv: {{ saltenv }}
    - watch:
      - virtualenv: doc
    - watch_in:
      - cmd: doc
{%- endif %}
