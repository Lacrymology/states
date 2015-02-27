{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

git_server_user_fake_mailbox_to_stop_userdel_error_log:
  file:
    - name: /var/mail/git
    - managed
    - makedirs: True
    - require_in:
      - user: git-server
