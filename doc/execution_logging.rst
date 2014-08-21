.. Copyright (c) 2014, Diep Pham
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
.. Neither the name of Diep Pham  nor the names of its contributors may be used
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

Script Execution Logging
========================

All important scripts such as backup scripts must log their execution
time to syslog.

Log Format
==========

Priority
  ``local7.info``

Tag
  ``<script_name>[<PID>]``

Content
  - Start with args: <arguments>
  - Finish after <execution_time> seconds, return code: <return_code>

Example::

  Aug 20 16:28:30 debbox backupdb[1890]: Start with args: all-db
  Aug 20 16:50:24 debbox backupdb[1890]: Finish after 22 seconds, return code: 0

Implementations
===============

Bash
----

All bash scripts have to require ``file: bash``.

File ``/usr/local/share/salt_common.sh`` (in ``bash`` formula)
contains two functions that log start and stop event of a script:
``log_start_script`` and ``log_stop_script``. Add following snippet to
the top of script that needs to log start and stop event.

::

   source /usr/local/share/salt-common.sh
   log_start_script "$@"
   trap "log_stop_script \$?" EXIT

.. warning::

   ``trap "log_stop_script \$?" EXIT`` line may override existing trap
   functions.
