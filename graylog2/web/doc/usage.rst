Graylog2 web interface user guide
=================================

.. Copyright (c) 2013, Quan Tong Anh
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Quan Tong Anh nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Web interface
-------------

If install had been OK, now you can access to the web interface via the URL that
is configured in the web server :doc:`pillar` ``graylog2:hostnames``.

After registering an admin user and login, take a look at over all tabs.

Since Graylog2 is already configured to transport email, belows are all the
steps that you need to do to get the notifications:

* Go to `streams` tab to create a stream (for e.g: shinken)
* Define filter rules for stream in `Rules` tab:

  * Level (or higher): Warn
  * Short Message (regex): :code:`[Ff]ailed|[Mm]issing|connection lost|down`

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
regex: :code:`[Oo]ut of [Mm]emory: [Kk]illed process|oom-killer`.

Create user
-----------

Go to `users` tab. Click `Create new user` button. Then put into `Username`,
`Sentry DSN`, `Email address`, `Name`, `Password`, `Confirm Password` and
lastone `Role`.

Note that if you want to user has full permission. Click choose Admin on `Role`.
Or you only want user has permission read permission. Let choose Reader on
`Role`.
