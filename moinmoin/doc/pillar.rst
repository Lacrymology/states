Pillar
======

Mandatory
---------

Optional 
--------

moinmoin:
  sitename: Your company name
  superusers:
    - spiderman
    - batman
  ldap: # config ldap as backend authenticate for moinmoin
    uri: 'ldap://example.com
    binddn: 'cn=admin,dc=example,dc=com'
    bindpw: 'passwordhere'
    basedn: 'dc=example,dc=com'
    ssl: idoic # config moinmoin use ldap with TLS for authenticate. See ssl/init.sls for more
