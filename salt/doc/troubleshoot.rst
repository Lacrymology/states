Troubleshooting
===============

If this log showed when using salt::

    /usr/local/lib/python2.7/dist-packages/raven/utils/__init__.py:13: UserWarning: Module _yaml was already imported from /usr/lib/python2.7/dist-packages/_yaml.so, but /usr/local/lib/python2.7/dist-packages is being added to sys.path

Make sure file ``/usr/lib/python2.7/dist-packages/_yaml.so`` exists.
If it doesn't, uninstall and then re-install PyYAML module by ``root``
user under system-wide python environment.
