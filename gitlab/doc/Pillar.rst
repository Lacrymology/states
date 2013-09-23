Pillar
======

Mandatory 
---------

gitlab:
  hostnames:                # Should not use `localhost`
    - 192.241.189.78

Optional 
--------

gitlab:
  smtp:
    enabled: Default is False

  workers: 2
  ssl: enable ssl. Default: False
  port: port to run gitlab web. Default: 80
  support_email: your support email
  default_projects_limit: 10

  database:
    host: localhost
    port: 5432
    username: postgre user. Default is git
    password: password for postgre user
  ldap:
    enabled: enable ldap auth, Default: False

gitlab:ldap:enabled 
~~~~~~~~~~~~~~~~~~~

If it's true, you must define:
gitlab:
  ldap:
    host: ldap ldap server, Ex: ldap.yourdomain.com
    base: the base where your search for users. Ex: dc=yourdomain,dc=com
    port: Default is 636 for `plain` method
    uid: sAMAccountName
    method: plain    # `plain` or `ssl`
    bind_dn: binddn of user your will bind with. Ex: cn=vmail,dc=yourdomain,dc=com
    password: password of bind user
    allow_username_or_email_login: use name instead of email for login. Default: true

gitlab:smtp:enabled
~~~~~~~~~~~~~~~~~~~

If it's true, you must define: 
gitlab
  smtp:
    server: your smtp server. Ex: smtp.yourdomain.com
    port: smtp server port
    domain: your domain
    from: smtp account will sent email to users
    user: account login
    password: password for account login
    authentication: Default is: `:login`
    tls: Default is: False
