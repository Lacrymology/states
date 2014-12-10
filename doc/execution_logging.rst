Script Execution Logging
========================

All important scripts such as backup scripts must log their execution
time to syslog.

Log Format
----------

Priority
  ``local7.info``

Tag
  ``<script_name>[<PID>]``

Content
  - Started with args: <arguments> / Started at <date>
  - Finish after <execution_time> seconds, return code: <return_code>

Example::

  Aug 20 16:28:30 debbox backupdb[1890]: Start with args: all-db
  Aug 20 16:50:24 debbox backupdb[1890]: Finish after 22 seconds, return code: 0

Implementations
---------------

Bash
~~~~

All bash scripts have to require ``file: bash``.

File ``/usr/local/share/salt_common.sh`` (in ``bash`` formula)
contains two main functions that log start and stop event of a script:
``log_start_script`` and ``log_stop_script``. Add following snippet to
the top of script that needs to log start and stop event.

::

   source /usr/local/share/salt-common.sh
   log_start_script "$@"
   trap "log_stop_script \$?" EXIT

.. warning::

   ``trap "log_stop_script \$?" EXIT`` line may override existing trap
   functions.

Besides that, it also include another function which is used to prevent the
script from running multiple instances at the same time: ``locking_script``.
For the script that you think must not run in parallel, add this function on
top of the ``log_start_script``, something like this::

   source /usr/local/share/salt-common.sh
   locking_script
   log_start_script "$@"
   trap "log_stop_script \$?" EXIT
