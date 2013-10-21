:Copyrights: Copyright (c) 2013, Hung Nguyen Viet

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
:Authors: - Hung Nguyen Viet

Pillar
======

Optional
--------

Example::

  clamav:
    dns_db:
      - current.cvd.clamav.net
    connect_timeout: 30
    receive_timeout: 30
    times_of_check: 24
    db_mirrors:
      - db.local.clamav.net
      - database.clamav.net

clamav:dns_db
~~~~~~~~~~~~~

Database verification domain, DNS used to verify virus database version.

Default: ``(current.cvd.clamav.net)`` by default of that pillar key.

clamav:connect_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds when connecting to database server.

Default: ``30`` by default of that pillar key.

clamav:receive_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds when reading from database server.

Default: ``30`` by default of that pillar key.

clamav:times_of_check
~~~~~~~~~~~~~~~~~~~~~

Numbers of database checks per day.

Default: ``24`` by default of that pillar key.

clamav:db_mirrors
~~~~~~~~~~~~~~~~~

Tuple of spam database servers.

Default: ``('db.local.clamav.net', 'database.clamav.net')``
by default of that pillar key.
