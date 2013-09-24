Pillar
======

Mandatory
---------

ldap:
  suffix: Domain component entry # Example: dc=example,dc=com
  usertree: salt path to user tree LDIF file # Example: user_stuff/ldaptree.ldif
  rootdn: Root Distinguished Name # Example: dn=admin,dc=example,dc=com
  rootpw: Root's password (can be created used ldappasswd)

ldap:usertree
~~~~~~~~~~~~~

If use `openldap/usertree.ldif.jinja2`, data from ldap:data will be used for creating LDAP users

Optional 
--------

ldap:
  log_level: 256
  data:
    mailname:
      user1:
        cn: CN user1
        sn: SN user1
        passwd: password of user1 (plaintext or created by ldappasswd)
        desc: description for user1
        email: other email of user1
      user2:
        cn: CN user2
        sn: SN user2
        passwd: password of user2
        desc:
        email:

ldap:data
~~~~~~~~~

nested dict contain user infomation, that will be used for create LDAP users and mapping emails (user@mailname) to mailboxes

ldap:log_level
~~~~~~~~~~~~~~

log verbose level, some values of this can be: -1, 256, 16383, ...
