Usage
=====

Web interface
-------------

If install had been OK, now you can access to the web interface via
the URL that is configured in the web server :doc:`pillar`
:ref:`pillar-graylog2-hostnames`.

After registering an admin user and login, take a look at over all tabs.

Since :doc:`/graylog2/server/doc/index` is already configured to
transport email, belows are all the steps that you need to do to get
the notifications:

* Go to `streams` tab to create a stream (for e.g:
  :doc:`/shinken/doc/index`)
* Define filter rules for stream in `Rules` tab:

  * Level (or higher): Warn
  * Short Message (regex): `[Ff]ailed|[Mm]issing|connection lost|down`

* `Settings` tab: uncheck **Stream disabled**
* `Alarms` tab: check on **Active** and **I want to receive alarms of this
  stream**

  * **Maximum number of messages**: 1
  * **Minutes**: 1
  * **Grace period (minutes)**: 1

  Don't forget to click on **Save** button.

Go to `users` tab and add the email address for each user that you want to
send him email notifications.

A usefull alarm is to check for Linux out of memory error, you can use this
regex: `[Oo]ut of [Mm]emory: [Kk]illed process|oom-killer`.

Create user
-----------

Go to `users` tab. Click `Create new user` button. Then put into `Username`,
`Sentry DSN`, `Email address`, `Name`, `Password`, `Confirm Password` and
lastone `Role`.

Note that if you want to user has full permission. Click choose Admin on `Role`.
Or you only want user has permission read permission. Let choose Reader on
`Role`.

Stream
------

For creating :doc:`/graylog2/doc/index` streams, see the `official
documentation
<http://docs.graylog.org/en/1.0/pages/streams.html>`_.

We predefined two streams for two common errors:

* Out of memory:

  * level must be smaller than ``5``

    Messages with log levels: warn, err, crit, alert, emerg

  * message must match regular expression ``(?i)(\boom\b|out of memory)``

    Messages must contains ``oom`` or ``out of memory`` string (case
    insensitive).

* Shinken Errors:

  * source must match regular expression ``^shinken.+``

    Source name must start with ``shinken`` string

  * level must be smaller than ``4``

    Messages with log levels: err, crit, alert, emerg

Avoid to use ``.*`` in regular expression of rule for stream, it's slow and
will be ``Paused`` by :doc:`index`.
See `Stream Processing Runtime Limits
<http://docs.graylog.org/en/1.0/pages/streams.html#stream-processing-runtime
-limits>`_
for more details.

Slack Plugin
------------

1. Create Slack API token

   The plugin configuration asks for a Slack API token which can be created by
   visiting https://api.slack.com/web and press "Create token". (make sure you are
   logged in)

2. Create alarm callback

   Create a "Slack alarm callback" on the "Manage alerts" page of the
   stream. Enter the requested configuration and save.
