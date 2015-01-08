Monitoring Checks
=================

For writing :doc:`/nrpe/doc/index` check with Python (recommend), see
:doc:`/doc/monitoring/python`.

Writing monitoring check is easy, and can be done with any programming
languages. We often use :doc:`/bash/doc/index` beside of
Python.

Return code
-----------

Monitoring check is a normal executable script, only the return code
has to follow a standard.

:doc:`/shinken/doc/index` the status of a host or service by
evaluating the return code from plugins.

+--------------------+---------------+-------------------------+
| Plugin Return Code | Service State |       Host State        |
+====================+===============+=========================+
|                  0 | OK            | UP                      |
+--------------------+---------------+-------------------------+
|                  1 | WARNING       | UP or DOWN/UNREACHABLE* |
+--------------------+---------------+-------------------------+
|                  2 | CRITICAL      | DOWN/UNREACHABLE        |
+--------------------+---------------+-------------------------+
|                  3 | UNKNOWN       | DOWN/UNREACHABLE        |
+--------------------+---------------+-------------------------+

Output
------

A line of text with additional information about the service state:

Example::

  DISK OK - free space: / 3326 MB (56%)

Example
-------

Following bash script is a complete check for monitoring free disk
space.

.. code-block:: bash


   df_output=$(df -h / | sed 1d)
   disk_used=$(echo "$df_output" | awk '{print $3}')
   disk_used_percent=$(echo "$df_output" | awk '{sub(/%/, "", $5); print $5}')

   if [[ "$disk_used_percent" -le 80 ]]; then
       echo "DISK OK - free space: / $disk_used ($disk_used_percent%)"
       exit 0
   elif [[ "$disk_used_percent" -le 90 ]]; then
       echo "DISK WARNING - free space: / $disk_used ($disk_used_percent%)"
       exit 1
   else
       echo "DISK CRITICAL - free space: / $disk_used ($disk_used_percent%)"
       exit 2
   fi

   exit 3  # I should not be here

:doc:`/shinken/doc/index` doesn't care about what happens inside of
the script, it only reads the output and return code.

NRPE checks repositories
------------------------

Before decide to write your own monitoring check, check if you can use
a existed one instead.

* `<http://nagios-plugins.org/>`__
* `<https://www.monitoring-plugins.org/>`__
* `<http://exchange.nagios.org/directory/Plugins>`__
