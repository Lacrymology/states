=========
Changelog
=========

2013-08-21 16:30:00 GMT+08:00
-----------------------------

39a9126c54d1177d12f22172358c7e54e5d70b24

New additions
=============

- Module 'password.pillar' used to generate random password if a pillar value
  isn't defined. Primary usage is to create account used within a single host.
- Module 'password.encrypt_shadow' that let you create encrypted user password
  for Linux.
- state module 'tcp_wrappers' to deal with /etc/hosts.allow and /etc/hosts.deny
- State module 'nrpe', mostly used for automated testing.
- Many test.sls file used to complete automated testing framework.
- A lof of new 'monitor.jinja2' used to let know monitoring which checks to
  perform to which states.
- 'backup.ssh' state to install a SSH based copy of backup archive to a remote
  server.
- 'backup.s3' state to install a client that copy backup archive to Amazon S3.
- Redis NoSQL database state
- 'bbb' state for Big Blue Button (bigbluebutton.org)
- Salt Cloud server states
- New documentation section
- LDAP server state
- ffmpeg state
- mscorefonts states
- NFS client and server states
- basic support for Ubuntu lucid
- PHP states and uWSGI support for it
- remove support for Amazon SES in graphite and sentry
- add some Java related states: Maven, Java 6 and Java 7 (and their JDK) &
  Tomcat 6 and Tomcat 7 states
- MariaDB state for MySQL support
- Added backup functionality to:
  - postgresql.server
  - mongodb

Updates
=======

- Better support for encoding settings. Default is UTF-8 (encoding pillar value).
- Testing framework had been updated to automatically create 99% of the tests to
  perform and it's now possible to write more complex test suite with salt
  states directly instead of writing python code.
- Automatic discovery mecanism used to configure monitoring. Requires less code
  and less human intervention.
- Better error handling in state 'dnsimple.present'
- All services now specify an "order" argument to make sure they run before
  automated testing.
- A lot of minor improvements.
- Most states ID are the same in their absent counterpart to make sure there is
  conflict of ID if the $state and $state.absent get both included in highstate
- More states had been migrated to salt-archive/mirror of files.
- all TAB (\t) characters had been replaced by spaces (\s)
- More doc
- More versions had been hardcoded

Fixes
=====

- Module pkg_installed had been updated to fix at least rare 2 bugs
- State 'apt_repository.present' now run apt-get update everytime it's required.
- No absent states are doing more than the minimum expected. no more include.
- Many minor fixes

Pillar
======

- two pillar key that used to be a URL/path to a file that contains private data
  had been replaced by pillar key that hold the contains of the file, so
  everything is in pillars:
  - apt_source replaced apt:sources (see apt/init.sls for details)
  - deployment_key_source replaced by deployment_key (see ssh/client/init.sls for details)
  - ssl had not beeb replace, but rather it's structure change, the content of SSL keys are now pillars. (see ssl/init.sls for details).
- Many new states added in this release have their own pillars key, please check
  those states for a list.
- Elasticsearch pillars data structure had been changed to allow more precision
  regarding service port, this was required to allow ES and GL2 server to run on
  the same host at the same time.
- The following pillars key aren't used anymore as they used to configure Amazon
  SES which is now deprecated:
  - graphite:email
  - amazon-ses
  - sentry:email
- Some keys had been added to replace old one:
  - graphite:smtp instead of graphite:email
  - sentry:smtp instead of sentry:email
- Many pillars values are now optional, default value are used when not specified:
  - debug
  - memcache:memory
  - graphite:db:name
  - graphite:db:username
  - graylog2:email:tls
  - graylog2:email:user
  - graylog2:email:password
  - rabbitmq:monitor:user
  - salt:version
  - sentry:db:name
  - sentry:db:username
- Some password related pillars values can be omitted as random string will be
  used instead, but keep pillar key if you're upgrading exinsting server:
  - graphite:db:password
  - postgresql:diamond
  - rabbitmq:monitor:password
  - sentry:db:password
  - sentry:django_key
- Some new pillar value are now mandatory with some states:
  - mail:mailname the SMTP mail hostname (many states)


2013-08-16 00:00:00 GMT+08:00
-----------------------------

bfb575a777b7dcc282e48f2d1389585fa620fc5d

New Additions
=============

- Add grains debian module
- Totally new way to handle monitoring configuration.
- Modules:
  - monitoring
  - nrpe
  - password
  - pkg_installed
  - tech_support
- States:
  - amavis
  - build
  - clamav
  - debian.package_build
  - java 6/7
  - tomcat 6/7
  - local
  - mail
  - mariadb (MySQL)
  - nfs server and client
  - openldap
  - postfix
  - dovecot
  - salt.archive
  - s3cmd
  - rsync
  - rssh
  - roundcube
  - raven.mail
  - python and python.dev
  - uwsgi.top
  - web
  - xml
- support for backup in amazon S3

Update
======

- simplify shinken state: split it into smaller states, one per shinken component
- improve route 53 state module
- add many absent states
- backup client and server, implement a simple way to use different backend
  storage for archive
- lot's of bugfixes

Fixes
=====

- npm module: support new version of npm
- better test mode handling
- few fixes in dnsimple state module
- pkg_file.installed use APT cache directory instead of Salt minion cache

2013-05-04 18:28:39 GMT+08:00
-----------------------------

Move all Python based nagios plugin to use a virtualenv (/usr/local/nagios)
instead of root python path.

2013-05-03 22:10:00 GMT+08:00
-----------------------------

469fe4f2d14e4f8691077771b67e19e82c28281c

- Add logrotate state
- Fixes a LOT of requirements
- Fix few permissions
- minor fixes

2013-05-01 18:00:00 GMT+08:00
-----------------------------

- Initial release of Salt Common States Beta.
