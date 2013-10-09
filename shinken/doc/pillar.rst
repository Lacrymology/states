shinken
ssl
roles
use_mongodb
user
email
architecture
	arbiter
	scheduler
	poller
		id
	broker
	reactionner
graphite_url
shinken:architecture:receiver
log_level
web
	hostnames
global_roles
monitoring
	states


Pillar
======

Mandatory
---------

  shinken:
    graphite_url: http://graphite.example.com 
    users:
      <username>:
        email:
        password:
    architecture:
      broker:
      arbiter:
      scheduler:
      reactionner:
      poller:
        id:
    web:
      hostname:
        - shinken.example.com

shinken:graphite_url
~~~~~~~~~~~~~~~~~~~~

Graphite address.

shinken:users
~~~~~~~~~~~~~

List contact users.
Please replace <username> by real username.
Example: ci, lam, hvn

shinken:<username>:email
~~~~~~~~~~~~~~~~~~~~~~~~

Shinken user's email

shinken:<username>:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Shinken user's password

shinken:architecture:broker
~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:arbiter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:scheduler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:reactionner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:poller:id
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:web:hostnames
~~~~~~~~~~~~~~~~~~~~~

List of HTTP hostname

Optional
--------

Example:

  shinken:
    ssl: False
    ssl_redirect: False
    log_level: INFO

shinken:ssl
~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key. 

shinken:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be redirected to HTTPS.

Default: ``False`` by default of that pillar key.

shinken:log_level
~~~~~~~~~~~~~~~~~

Define level of logging.

Default: ``INFO`` by default of that pillar key.