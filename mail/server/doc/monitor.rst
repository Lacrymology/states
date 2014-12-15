Monitor
=======

Optional
--------

.. _monitor-mailstack_functionality:

mailstack_functionality
~~~~~~~~~~~~~~~~~~~~~~~

Check the functionality of the mail stack by sending a normal, a spam, and
a virus mail to see all corresponding parts work functionally.
If this check failed, look into the message that the check returned,
it may caused by the slowness of mail processing, then raising
:ref:`pillar-mail-check_mail_stack-smtp_wait` to higher value may help fixing
this. Spam-filter (:doc:`/amavis/doc/index`) or virus scanner
(:doc:`/clamav/doc/index`) did not work may also cause failure of this.

Only check if :ref:`pillar-mail-check_mail_stack` is defined.
