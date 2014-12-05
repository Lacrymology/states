.. Copyright (c) 2014, Tomas Neme
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
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
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

Python
======

Writing monitoring scripts in python is quite simple using `the
nagiosplugin library <http://pythonhosted.org/nagiosplugin/>`__

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
the value class with which collected  ``Resource``s are passed on to
``Context``s and ``ScalarContext``, which is a class that knows how to
evaluate a number according to a range and set it as ``OK``,
``WARNING`` or ``CRITICAL``.

The following is a minimal but realistic check to retrieve the used
diskspace on the root partition::


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
        nagiosplugin.ScalarContext("used", ":1000000000", ":1900000000")
        nagiosplugin.ScalarContext("free", ":1000000000", ":1900000000")
        nagiosplugin.ScalarContext("percentage", ":80", ":95")
    )
    check.main()
