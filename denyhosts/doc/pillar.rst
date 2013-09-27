Pillar
======

Mandatory
---------

Optional
--------

denyhosts:
  purge: 1d
  deny_threshold_invalid_user: 5
  deny_threshold_valid_user: 10
  deny_threshold_root: 1
  reset_valid: 5d
  reset_root: 5d
  reset_restricted: 25d
  reset_invalid: 10d
  reset_on_success: no
  sync:
    server: 192.168.1.1
    interval: 1h
    upload: yes
    download: yes
    download_threshold: 3
    download_resiliency: 5h
  whitelist:
    - 127.0.0.1
shinken_pollers:
  - 192.168.1.1

shinken_pollers
~~~~~~~~~~~~~~~

IP address of monitoring poller that check this server.

denyhosts:purge
~~~~~~~~~~~~~~~

each of these pillar are documented in
salt://denyhosts/config.jinja2.
