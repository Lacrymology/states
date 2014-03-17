:copyrights: Copyright (c) 2014, Dang Tung Lam

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.
             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:authors: - Dang Tung Lam

Test Sentry Alert
=================

This formula will install an executable script that check the activity of Sentry.
After installed, this script will emulate ``/usr/bin/mail`` but send an event to
your Sentry server instead.
To start checking, please run command::

    echo "My Test" | /usr/bin/mail

Then, check your mailbox or Sentry WebUI for result.

To install ``raven.mail`` please see installation instruction page `<install.html>`_.

An other way, if you don't like install ``raven.mail``, you can use Python
script ``raven/mail/script.py``. It requires ``SENTRY_DSN``
environment variable and Sentry client for Python.

Install Sentry client through ``pip``::

    # Install pip
    sudo apt-get install python-pip
    # Install python-raven
    pip install raven simplejson

Define your Sentry DSN::

    export SENTRY_DSN=http://your_sentry_dsn

And run following command to check::

    echo "test" | python script.py

Check your mailbox or Sentry WebUI for result.

.. toctree::
     :glob:

     *
