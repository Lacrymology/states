{#- Usage of this is governed by a license that can be found in doc/license.rst
 -*- ci-automatic-discovery: off -*-
-#}

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
