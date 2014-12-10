Documentation writing guidelines
================================

Documentation targets Linux system administrator, who doesn't know everything.

Style
-----

Uses third-person perspective and avoid "I", "we", "you".

Common guidelines
-----------------

- Do not put LICENSE to a documentation file. Writing doc is not a fun task,
  makes it as simple/easy as possible.
- Every level 2 headers of ``metrics.rst`` and level 3 headers of
  ``monitor.rst`` and ``pillar.rst`` must have a Sphinx_Ref_ on top of them,
  in the following format::

    .. _$TYPE-root_key-sub_key:

    root_key:sub_key
    -$HEADER_MARKUP~

  Replace ``:``, ``.``, ``{{ `` and `` }}`` with ``-``.

- If something refers to an other formula, puts link to such doc instead of
  name. E.g. access to :doc:`/ssh/doc/index` port ...
- If no page can be found, copy content from somewhere and use a comment
  to refer to the source, example::

      .. Copied from Linux kernel source doc/something.txt version 3.11.4

      [copied stuff]

- If referring to something outside the formula, puts link to open-source or
  technology page or Wikipedia page.
- Underlining section titles uses ``=``, ``-``, ``~`` for level 1, 2 and 3
  respectively. Section title level > 3 seems too deep and should be avoid.
- Quotes UNIX commands, example:

  Not good::

     Maximum number of open files (for ulimit -n)

  Better::

     Maximum number of open files (for ``ulimit -n``)

Pillar documentation
--------------------

- Documents the data format, not what it is used for.
- Every pillar key must have a Sphinx_Ref_ on top of them, in the following
  format::

    .. _pillar-root_key-sub_key:

    root_key:sub_key
    ~~~~~~~~~~~~~~~~

- Default value must use the following format, if default value is Python
  value::

    Default: $DESCRIPTION (``$DEFAULT_VALUE``).

  Or::

    Default: ``6`` hours.

  If it's a string, a number of a boolean the following can be used::

    Default: Unlimited time (``inf``).

  instead of::

    Default: ``'inf'`` - means unlimited time.

  because the former is shorter and easier to read.
- Documents the data format and its value. If it has default value,
  why such default value? What consume it ?  and what is the impact
  of changing pillar? is there any risk to set a different value?
- Be clear on the impact of key, value in plain English words,
  not just Python value (do not assume user knows Python).
  Example with ``mail:maxproc``:

  Not good::

    Maximum number of processes.

    Default: ``2``.

  Better::

    Maximum number of processes of:

    - ``amavisd`` child processes (not including the main process).
    - ``amavisfeed``, amavis service of :doc:`/doc/postfix/index`

    Default: ``2`` processes each.  This value reflects the default of 2
    amavisd-daemon children processes and is a good setting to start from.
    The value may be raised later, when the system works stable and still
    can take a higher load. Same value used to configurate both software
    as one of :doc:`/doc/postfix/index` should never exceed one of
    :doc:/doc/amavis/index`.
    Consult http://www.ijs.si/software/amavisd/README.postfix for more detail.

  or with ``amavis:check_virus``:

  Not good::

    Enable or disable virus checking.

    Default: ``True``.

  Better::

    Enable or disable :doc:`/clamav/doc/index` virus checking.

    Default: virus checking is enabled (``True``).

- If pillar is numerical value, explains why such value. Example:

  Not good::

    Maximum number of open files (for ``ulimit -n``)

    Default: ``131072``.

  why 131072? where does that come from? is it because of
  it's default value in Ubuntu package of that program?

- Add ``.. note::`` or ``.. warning::`` if necessary. Example on
  :ref:`pillar-amavis-warn_spam_sender`:

  Not good::

    Notify spam sender or not.

    Default: ``False``.

  Better::

    Notify sender that they sent a mail which flagged as spam.

    .. warning::

      It's not recommended to turn that on as it might generate a lot of
      new email to probably non-existing email account.

    Default: No notification are sent (``False``).

- If value is in a standard format (not a string, not a int,
  not a list of either) but rather a specific form,
  link to specification of such format, such as:

  https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation
  https://en.wikipedia.org/wiki/IPv6#Address_representation

Monitor documentation
---------------------

The purpose of monitor documentation is to explain what does each check mean
and is the first place to see if a check failed.

Documentation for check must do following things:

- Explaining what is that check.
- Every monitor check must have a Sphinx_Ref_ on top of them, in the following
  format::

    .. _monitor-root_key-sub_key:

    root_key:sub_key
    ~~~~~~~~~~~~~~~~

- Explain what does it mean if the check is failed if it is not obvious
  and proposal how to do more troubleshooting or fix it.
  E.g. rsyslog_procs explanation is : rsyslog process is running,
  so if the check failed, it was because of the process is not running,
  therefore no need to document that but need to suggest how to troubleshooting
  and fix the problem.
- Not expose detail implementation, it's better to write "SSH port can be
  reached from outside" than "Port 22 ...".
  The implementation may change in the future, if the doc is not too
  specific, then there is no need to update it when the implementation change.
- If explanation is long and exists in software documentation,
  link to that documentation instead of copy/rewriting.

Metric documentation
--------------------

The documentation must answer the following questions:

- What is this metric?
- Every metrics name must have a Sphinx_Ref_ on top of them, in the following
  format::

    .. _metrics-root_key-sub_key:

    root_key.sub_key
    ----------------

- What does it mean to the system/service if the value is too high/ too low,
  change too fast or too slow, etc...

.. _Sphinx_Ref: http://sphinx-doc.org/markup/inline.html#cross-referencing-arbitrary-locations
