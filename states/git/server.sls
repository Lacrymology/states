{#
 using this state the git repo URLs are:
 ssh://git@{{ address }}/~git/{{ reponame }}.git
 #}

include:
  - git

git-server:
  user:
    - present
    - name: git
    - gid_from_name: True
    - shell: /usr/bin/git-shell
    - home: /var/lib/git-server
    - require:
      - pkg: git

{% for user in pillar['git-server']['keys'] %}
git-server-key-{{ user }}:
  ssh_auth:
    - present
    - user: git
    - require:
      - user: git-server
    - enc: {{ pillar['git-server']['keys'][user]['enc'] }}
    - name: {{ pillar['git-server']['keys'][user]['key'] }}
{% endfor %}

{% for repository in pillar['git-server']['repositories'] %}
/var/lib/git-server/{{ repository }}.git:
  file:
    - directory
    - user: git
    - group: git
    - mode: 700
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
{% endfor %}
