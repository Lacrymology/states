{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - git
  - ssh.server

git-server:
  user:
    - present
    - name: git
    - gid_from_name: True
    - shell: /usr/bin/git-shell
    - home: /var/lib/git-server
    - require:
      - pkg: git

{% for key in salt['pillar.get']('git-server:keys') %}
git_server_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: git
    - require:
      - user: git-server
    - enc: {{ salt['pillar.get']('git-server:keys')[key] }}
{% endfor %}

{% for repository in salt['pillar.get']('git-server:repositories') %}
/var/lib/git-server/{{ repository }}.git:
  file:
    - directory
    - user: git
    - group: git
    - mode: 770
    - makedirs: True
    - require:
      - user: git-server
  module:
    - wait
    - name: git.init
    - kwargs:
      cwd: /var/lib/git-server/{{ repository }}.git
      opts: --bare
      user: git
    - watch:
      - file: /var/lib/git-server/{{ repository }}.git

/var/lib/git-server/{{ repository }}.git/description:
  file:
    - managed
    - user: git
    - group: git
    - mode: 440
    - template: jinja
    - source: salt://git/server/description.jinja2
    - context:
        repository: {{ repository }}
    - require:
      - module: /var/lib/git-server/{{ repository }}.git
{% endfor %}
