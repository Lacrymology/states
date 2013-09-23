Pillar
======

Mandatory 
---------

message_do_not_modify: Warning message to not modify file.

git-server:
  keys:
    00deadbeefsshkey: ssh-dss
  repositories:
    - myreponame

git-server:keys
~~~~~~~~~~~~~~~

dict of all users that can access the git repository. Each key is a dict of the SSH 
public key and the value is the key format.

git-server:repositories
~~~~~~~~~~~~~~~~~~~~~~~

list of all repo handled by the server.
On first run, repo are created as "bare" and need to be pushed into.

Optional
--------

destructive_absent: False

destructive_absent: If True (not default), git repositories will be wiped if
git.server.absent state is executed.
