message_do_not_modify: "managed by salt, don't manually change"
salt_master:
  gitfs_remotes:
    - git@git.bit-flippers.com:~git/salt-hvn.git
    - git@git.bit-flippers.com:~git/salt-common.git

apt_source: salt://apt_sources.jinja2
ubuntu_mirror: us.archive.ubuntu.com/ubuntu
mail:
  mailname: hvnsweeting.com
  maxproc: 5
