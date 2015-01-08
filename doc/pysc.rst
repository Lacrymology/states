PYSC
====

``pysc`` stands for "Python Library for Salt-Common", it contains
helper functions and classes used throughout the :doc:`Common
</doc/intro>` python code which provide shortcuts and facilities for
common functionality and configurations such as logging, yaml config
file unserialization, process configuration and most prominently a
base class to create python command line applications that use common
configurations and command line interfaces, and a simplified approach
to crating nrpe checks for your formulas.

.. contents::

Helper functions
~~~~~~~~~~~~~~~~

The following functions are defined in the ``pysc`` module:

- ``unserialize_yaml(filename, critical=False)``: unserializes the
  yaml file indicated by ``filename`` and returs its value. It expects
  the file to unserialize as a dictionary. If not, or if an exception
  is raised when opening or unserializing the file, an error is logged
  and an empty dictionary is returned unless ``critical`` is True-ish,
  in which case an exception is raised.
- ``dict_merge``: deep merge of two dictionaries.
- ``set_logging_debug``: sets logging to print to stdout at level
  ``DEBUG``
- ``drop_privilage(user_name, group_name)``: Changes the process user
  and group accordingly.
- ``profile``: decorator that profiles a function call.
- ``ignore_errors``: decorator that ignores any non system-terminating
  exceptions and continues execution.

.. _pysc.Application:

Base Application
~~~~~~~~~~~~~~~~

The target of the ``pysc.Application`` class is both to facilitate
creation of command line applications for robotinfra-based
systems and to enforce some kind of standardization on command-line
arguments and configuration files format and locations.

To create a basic application, the user needs to create a class that
inherits from ``pysc.Application``, define the ``main`` method and
call ``run``::

    from psyc import Application

    class MyApp(Application):
        def main(self):
            print self.config

    if __name__ == '__main__':
        MyApp().run()

Advantages
----------

A list of the things that get taken care for you if you use
``pysc.Application``:

- **standardization**: Using this class and following the guidelines
  will help you make all of your applications callable in a similar
  way and have them accept the same format of config files, which will
  help to keep your system coherent and maintainable, and to minimize
  the cost of training new users.
- **configuration files loading**: A config file is required (but a
  default is provided by **robotinfra**), the
  config file may define other config files to be loaded as well. All
  config files are deserialized as yaml.
- **debug mode**: a simple ``--debug`` flag to override logging
  configuration so everything gets logged to console
- **profiling** of your script.
- **process name**: the process name will be automatically changed to
  match the name of the file your ``Application`` subclass is defined
  in
- **logging configuration**: define a logging config dictionary in
  your config file (again, there's a reasonable default provided by
  **robotinfra**) and ``Application`` gracefully falls back to
  printing to the console if there's any problem in it.

Usage
-----

Subclass ``pysc.Application`` and call the ``run`` method, as
described above. Optionally, you can also override the following
class-level attributes:

- `name`: This will be used to change the process name instead of the
  filename.
- `defaults`: An optional dictionary of default configuration values.
  Notice that this has lower priority than command line arguments, so
  if you want to, for example, change the default value of the config
  file, this won't work. To do it, please do the following::

    class MyApp(Application):
        def get_config_parser(self):
            argp = super(MyApp, self).get_config_parser()
            argp.set_defaults(config="/custom/config/path.yml")
            return argp

- `logger`: the logger to be used in case of errors. This can be
  either a string or an instance of ``logging.Logger``, and it
  defaults to the calling class' containing ``__module__``

A more complete example::

    #!/usr/bin/env python

    import pysc

    class MyApp(pysc.Application):
        name = 'my-custom-command'
        defaults = {
            'foo': 1,
            'bar': 2,
        }
        logger = 'custom.logger'

        def get_argument_parser(self):
            argp = super(MyApp, self).get_argument_parser()
            argp.add_argument("--baz", default=3)
            argp.set_defaults(config="/etc/custom/config.yml")
            return argp

        def main(self):
            self.logger.info("Ready to do my thing")
            print "foo", self.config['foo']
            print "bar", self.config['bar']
            print "baz", self.config['baz']
            self.logger.debug("This was configured with %s",
                              self.config['config'])

    if __name__ == '__main__':
        MyApp().run()

And when invoked::

    $ ./myapp
    foo 1
    bar 2
    baz 3

    $ ./myapp --debug
    DEBUG:custom.logger:running main
    INFO:custom.logger:Ready to do my thing
    foo 1
    bar 2
    baz 3
    DEBUG:custom.logger:main finished

    $ ./myapp --debug --set='{"profile": true}'
    DEBUG:custom.logger:running main
    INFO:profile:main started at 2014-11-12 22:42:17.663816
    INFO:custom.logger:Ready to do my thing
    foo 1
    bar 2
    baz 3
    DEBUG:custom.logger:This was configured with /etc/custom/config.yml
    INFO:profile:main ended at 2014-11-12 22:42:17.717612
    INFO:profile:main ran in 0.053796 seconds. (pcputimes(user=0.27, system=0.06))
    DEBUG:custom.logger:main finished

    $ ./myapp --baz BAZ
    foo 1
    bar 2
    baz BAZ

    $ ./myapp --set='{"foo": "FOO", "bar": 42, "baz": 1024}'
    foo FOO
    bar 42
    baz 1024

    $ ps awwx | grep command
    31056 pts/16   T      0:00 my-custom-command
    31064 pts/16   S+     0:00 grep --color=auto command


Options and configurations
--------------------------

``pysc.Application`` provides a set of command line arguments, and
processes all arguments and configuration files a dictionary which the
application can use later on. All values read from configuration
files and command line options are aggregated into a dictionary that
the application class can refer to as ``self.config``. All
configuration files must be yaml files representing a dictionary.

Command line options
++++++++++++++++++++

--config
********

The path to the main configuration file. Defaults to
``/etc/python/config.yml"``.

--debug
*******

Ignores other logging configs and logs to console at all levels. It
also opens a python debugger on error

--set=<json>
************

Set arbitrary configuration options, the option value must be a valid
JSON dictionary (object). This has priority so it overrides any other
configuration sources that might define the same value. Please
remember that strings in JSON are delimited by ``"``, not by ``'``, so
this is valid::

    $ myapp --set='{"profile": true}'

but this is not::

    $ myapp --set="{'profile': true}"

Adding custom command line options
**********************************

To add command line options, the Application class has to override
the ``get_argument_parser`` method and add it's desired options to the
parent class' provided ``ArgumentParser``::

    class MyApp(Application):
        def get_argument_parser(self):
            argp = super(MyApp, self).get_argument_parser()
            argp.add_argument("--foo", action=count, default=0,
                              help="How many foos do you want?")
            return argp

        def main(self):
            for _ in range(self.config['foo']):
                print "foo"

Calling this script will behave like this::

    $ test.py
    $ test.py --foo
    foo
    $ test.py --foo --foo --foo
    foo
    foo
    foo

Wherever possible, we encourage to avoid adding command line options.
Usage of the ``--set`` option or config files is preferred, but if the
script is designed to be used manually by the sysadmins then this is
probably the best way.

Configuration values
++++++++++++++++++++

The following configuration values are expected or supported:

- `logging`: Is expected to be a valid configuration dictionary for
  python's `logging.config.dictConfig
  <https://docs.python.org/2/library/logging.config.html#logging.config.dictConfig>`_.
  A default is provided in ``/etc/python/config.yml``
- `profile` (optional): Should be a boolean. If ``True`` a
  ``log.debug`` message is emitted when the application starts, after
  it ends, and counting the total time
- `process` (optional): If present, the process user and groups will
  be changed to the provided values. It should be a dictionary like
  this::

    process:
        user: someusername
        group: somegroupname

- `graphite` (optional): ``"<server>[:<port>]"``. If present, a
  ``pystatsd.Client`` is created and available to the Application at
  ``self.stats``. If the port is omitted, graphite's default (2003) is
  used.
- `lock` (optional): ``/path/to/lock``. If present, a lockfile is
  created when the application runs. If the lockfile already exists,
  the application exits with an error.
- `extra_configs` (optional): If present it should be a list of paths
  to config files. The configuration keys defined in those files will
  be added to the ``config`` dictionary. This has the lowest priority,
  so any values redefined either in the main config file or from the
  command line take precedence.


.. py:module:: pysc.nrpe

NRPE
~~~~

The ``pysc.nrpe`` module provides a simplified functional way of
creating NRPE checks (nagios plugins) for your services and formulas.
Its main concerns are:

- **standardization** of interfaces in order to create checks that are
  called identically across the system. This simplifies maintenance,
  development and training of new sysadmins and developers.
- offering a **simple** interface to generate checks.

.. This should really be documented as a function, but now may not be
   the right moment
   .. py:function:\: pysc.nrpe.check(function, defaults=None)

   \:param func function: The nagiosplugin check preparation function
   \:param dict defaults: A dictionary of default config values

   It is not a module, but module creates no output, so it's what we
   need right now

.. py:module:: pysc.nrpe.check

A ``pysce.nrpe.check`` application is a :ref:`pysc.Application
<pysc.Application>` and it supports all of its command line arguments
and configuration values. It also adds some arguments of its own and
changes the default config file.

However, to maintain readability of the nrpe formulas and
predictability of usage ``pysc.nrpe`` does **not** allow to extend
command line arguments.
Users are encouraged instead to add the required arguments to the
``arguments`` key of the check configuration in
``<formula>.nrpe.config.jinja2``. In the case that this is not
possible or adviceable for some reason, as a last resort you can use
the ``--set='{"key": "value"}'`` command line argument, but this is
not recommended.

``pysc.nrpe``-based checks use `nagiosplugin`_ so there is a minimum of
boilerplate involved. `nagiosplugin`_ takes care of transforming the
output of some python classes into the nrpe standard output format and
response codes, etc. so you can concentrate on writing your code, but
there's still some pretty rigid conventions to follow.

A check usually consists on one or more ``nagiosplugin.Resource``
instances which represent the things to be measured, and one or more
``nagiosplugin.Context`` instances which are classes that analyze the
``Resource``'s output and decide whether the result is valid or not. A
number of other classes can be used to customize output format and
result interpretation, but a basic ``ScalarContext`` is provided by
``nagiosplugin`` which should serve for most basic cases. Please see
the `nagiosplugin`_ documentation for more details.

Usage
-----

To create a nagios plugin you need at the very least to create your
``Resource`` class and then register it with ``pysc.nrpe.check``.
Here's a simple example::

    import nagiosplugin
    from pysc import nrpe

    class Universe(nagiosplugin.Resource):
        def probe(self):
            return [nagiosplugin.Metric("answer", 42)]

    def check_universe(config):
        return (
            Universe(),
            nagiosplugin.ScalarContext("answer", "{0}:{0}".format(
                config['answer'])),
        )

    nrpe.check(check_universe, {"answer": 42})

Let's take a look to what's going on there: In the last line, the
function ``check_universe`` is registered as the `prepare function`.
This is the function that will receive the parsed config options and
command line arguments as the first (and only) parameter ``config``
and return a sequence of arguments to be passed to a
``nagiosplugin.Check`` instance that will be prepared by the ``pysc``
library with some custom settings. The second argument to the
``nrpe.check`` function is an optional dictionary of default values
which will be inserted into the configuration values pipeline. The
call to this check should be something similar to this::

    $ universe_check --formula universe --check universe_check
    UNIVERSE OK - answer is 42 | answer=42;42:42

If you want, you can pass it a different expected answer than the
default, just to test that the check works as expected::

    $ universe_check --formula universe --check universe_check --set='{"answer": 60}'
    UNIVERSE WARNING - answer is 42 (outside range 60:60) | answer=42;60:60
    $ universe_check --formula universe --check universe_check --set='{"answer": 30}'
    UNIVERSE WARNING - answer is 42 (outside range 30:30) | answer=42;30:30

You can also change the value for the ``answer`` parameter in the
formula configuration file (by default
``/etc/nagios/nsca.d/universe.yml``, in this case)::

    universe_check:
      ...
      arguments:
        answer: 36

Command Line arguments
----------------------

In addition to the arguments defined by :ref:`pysc.Application
<pysc.Application>`, the following arguments are supported:

--formula
+++++++++

**Mandatory**. The name of the formula. This is used together with the
``nsca_dir`` configuration key to build the filename of the checks
configuration.

--check
+++++++

**Mandatory**. This is expected to be one of the keys in the formula
configuration file selected by ``--formula``

--cronjob
+++++++++

Set this flag when the check is ran from a cronjob rather than from
nrpe or the nsca daemon. This makes the check write its results to a
file to be collected later.

--cronresult
++++++++++++

When this flag is set, the job reads the results from the file a check
ran with the ``--cronjob`` flag and formats the results for nrpe.

--verbose
+++++++++

The standard ``-v`` flag for nagios plugins, adds verbosity to the
plugin output.

Migrating old nrpe checks
-------------------------

There's two main things you have to take care of when migrating old
nagios plugins:

1. you have to fix any usage of custom command line arguments you
   might have added. For the sake of standardization, ``pysc.nrpe``
   is quite inflexible and doesn't allow you to define custom command
   line arguments. Any command line arguments or configuration values,
   including the keys added to the ``arguments`` dictionary in
   ``/etc/nsca.d/<formula>.yml`` are accessible through the ``config``
   parameter of the check preparation function, so adding them there
   is encouraged.
2. Instead of creating a ``nagiosplugin.Check`` instance yourself, you
   return the parameters you would pass to its constructor as a
   sequence (normally a tuple) from the `prepare function`. In it
   you can use the config values to pass parameters to the
   ``Resource`` class constructors to be used by the check.

As a little extra, remember that:

3. If you are using a logger in your check (you should be), the logger
   name should start with ``nagiosplugin.`` (so for example
   ``nagiosplugin.universe`` would be a good name for the example
   check above), and it should be saved to a variable called ``log``
   at the module level. ``pysc.nrpe`` does magic to retrieve this
   variable, and if it doesn't exist it uses a logger called
   ``nagiosplugin.<filename of the test>``.

.. _nagiosplugin: https://pythonhosted.org/nagiosplugin/
