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
