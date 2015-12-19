{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - git
  - git.server.user
  - ssh.server

{%- set keys = salt['pillar.get']('git_server:keys') %}
{% for key in keys %}
  {%- set key_type, key_content = key.split()[:2] %}
git_server_ssh_auth_{{ loop.index }}:
  ssh_auth:
    - present
    - name: {{ key_content }}
    - user: git
    - require:
      - user: git-server
    - enc: {{ key_type }}
{% endfor %}

{% for repository in salt['pillar.get']('git_server:repositories') %}
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
    - contents: {{ repository }}
    - require:
      - module: /var/lib/git-server/{{ repository }}.git
{% endfor %}
