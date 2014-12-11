..
   Copyright (c) 2014, Tomas Neme
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

       1. Redistributions of source code must retain the above copyright notice,
          this list of conditions and the following disclaimer.
       2. Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.

   Neither the name of Bruno Clermont nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

Python
======

Writing monitoring scripts in python is quite simple using `the
nagiosplugin library <http://pythonhosted.org/nagiosplugin/>`__.

:doc:`salt-common </doc/intro>` provides :ref:`pysc.nrpe` as a
not-so-light wrapper nagiosplugin library that takes away some of
the boilerplate and helps achieve some desireable qualities in the
monitoring scripts: it provides centralized logging configuration,
allows for automatically adapting long-running checks to be run
outside of the nsca [#nsca]_ daemon and allows for a common,
maintainable configuration schema.

Subtitle
--------

Since NRPE dictates a simple but strict protocol regarding plugins
return values, syntax, nagiosplugin simplifies a lot of the
boilerplate asociated with the common tasks of nagios plugin
monitoring, like interpreting the `nagios range syntax
<https://nagios-plugins.org/doc/guidelines.html#THRESHOLDFORMAT>`,
evaluating the collected metrics according to said range syntax, and
setting the application's exit code according to the NRPE protocol.

The nagiosplugin library provides good default classes that know how
to handle scalar (numeric) metrics and how to evaluate them according
to the standard nagios range syntax, which should serve for most
monitoring purposes and it's flexible and overrideable enough to
generate custom output and evaluation modes.

As explained in the official documentation, the separation of concerns
in nagiosplugin is as follows: *data acquisition* is done by a
``Resource`` class, *data evaluation* is handled by a ``Context``
class, and *results presentation* is done by a ``Summary`` class. In
most cases, you will only need to extend a single ``nagiosplugin``
class: ``Resource``, and to use two more classes: ``Metric``, which is
the value class with which collected  ``Resource`` s are passed on to
``Context`` s and ``ScalarContext``, which is a class that knows how to
evaluate a number according to a range and set it as ``OK``,
``WARNING`` or ``CRITICAL``.

The default ``Summary`` class returns a very simple output, a string
representation of the "worse" metric when there's a problem, and a
string representation of the first metric when the overall result is
``OK``. It's poor, but it's enough in most cases.

The following is a minimal but possibly useful check to retrieve the used
diskspace on the root partition:

.. code-block:: python

    import subprocess
    import nagiosplugin

    class DiskSpace(nagiosplugin.Resource):
        def probe(self):
            line = subprocess.check_output("df /".split()).split("\n")[1]
            dev, size, used, free, perc, mount = line.split()
            used = int(used)
            free = int(free)
            perc = int(perc[:-1]) # drop the '%' before converting
            return [
                nagiosplugin.Metric("used", used)
                nagiosplugin.Metric("free", free)
                nagiosplugin.Metric("percentage", perc)
            ]

    check = nagiosplugin.Check(
        DiskSpace(),
        nagiosplugin.ScalarContext("used", ":800000000", ":950000000")
        nagiosplugin.ScalarContext("free", ":200000000", ":50000000")
        nagiosplugin.ScalarContext("percentage", ":80", ":95")
    )
    check.main()

This check measures the free space in the hard drive, and emits three
metrics from it, ``used``, ``free`` and ``percentage``. Assuming a
1GB HDD, it will return ``OK`` if there's less than 800MB are
used, ``WARNING`` if between 800MB and 950MB are used, and
``CRITICAL`` if 950MB or more are used. The three metrics it emits are
really redundant, since they can all be calculated from one another,
but it's a way to show that a single ``Resource`` can emit more than
one ``Metric``. Metrics are matched to Contexts by name. If for some
reason you have a metric that you wish to evaluate with a context with
a different name, you can pass a ``context=context_name`` kwarg to the
``Metric`` constructor. For example, you might want to measure the
free space of more than one disk, and have the metrics called
``disk0-free`` and ``disk1-free`` respectively, but all of them might
be evaluated by the same context, ``ScalarContext('percentage', ":80",
":95")`` so you can do the following in your ``Resource`` class:

.. code-block:: python

    ....
    def probe(self):
        ....
        return [
            Metric("disk0-free", disk0_free_perc, context='percentage')
            Metric("disk1-free", disk1_free_perc, context='percentage')
        ]

If the output the default ``Summary`` class is too simplified for your
test and you want something that helps you debug problems a little
better, you can define your own ``Summary`` class and add it to the
constructor of the ``Check`` class, just have in mind that NRPE requires
the output length to be less than 512B. The ``Check`` constructor
doesn't really care about the order of the parameters, it checks its
classes and adds them at the right point of the processing chain
automagically.

Likewise, if you'd like to return values different than numbers in
your ``Metric`` instances and want to evaluate them in a custom
manner, you will need to implement a ``Context`` class of your own as well.

.. rubric:: Footnotes

.. [#nsca] Nagios Service Checks Acceptor: The passive checks daemon.
		   See `<http://exchange.nagios.org/directory/Addons/Passive-Checks/NSCA--2D-Nagios-Service-Check-Acceptor/details>`_
		   for details
