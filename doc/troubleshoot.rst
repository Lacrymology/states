Troubleshooting
===============

Tech Support
------------

Like Cisco's ``show tech-support``, there is an equivalent in these states.

In case of error during a state execution, please run the following module after
the error happens.

From the master::

    salt -t 600 [minion-id] tech_support.show > /path/to/file.yaml

The ``-t 600`` is required as the execution of this module might take a long
time and timeout.

Or if you're on the minion::

    salt-call tech_support.show > /path/to/file.yaml

Job Output
----------

The output of the failed job is required too, on the salt master run::

    salt-run jobs.lookup_jid [job ID that failed] > /path/to/job.yaml

Send both file to report the error.
