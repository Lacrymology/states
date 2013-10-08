Pillar
======

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
  workers: 2
  cheaper: False

moinmoin:sitename
~~~~~~~~~~~~~~~~~

MoinMoin site name
Default: use MoinMoin default value

moinmoin:superusers
~~~~~~~~~~~~~~~~~~~

list of MoinMoin superuser.
Default: no set

moinmoin:ldap
~~~~~

data for binding with ldap

moinmoin:workers
~~~~~~~~~~~~~~~~

number of workers to use for uwsgi
Default: 2

moinmoin:cheaper
~~~~~~~~~~~~~~~~

use uwsgi cheaper mode or not
