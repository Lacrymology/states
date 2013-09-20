{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn

Git Server
==========

Install a simple Git source control management server.

using this state git repo URLs are:
ssh://git@{{ address }}:~git/{{ reponame }}.git

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

git-server:
  keys:
    00deadbeefsshkey: ssh-dss
  repositories:
    - myreponame

git-server:keys: dict of all users that can access the git repository. Each
    key is a dict of the SSH public key and the value is the key format.
git-server:repositories: list of all repo handled by the server.
    On first run, repo are created as "bare" and need to be pushed into.

Optional Pillar
---------------

destructive_absent: False

destructive_absent: If True (not default), git repositories will be wiped if
    git.server.absent state is executed.
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

{% for key in pillar['git-server']['keys'] %}
git_server_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: git
    - require:
      - user: git-server
    - enc: {{ pillar['git-server']['keys'][key] }}
{% endfor %}

{% for repository in pillar['git-server']['repositories'] %}
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
