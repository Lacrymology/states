{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
git-server:
  group:
    - absent
    - name: git
    - require:
      - user: git-server
  user:
    - absent
    - name: git
    - force: True
    - purge: True
  file:
    - absent
    - name: /var/lib/git-server/.ssh
